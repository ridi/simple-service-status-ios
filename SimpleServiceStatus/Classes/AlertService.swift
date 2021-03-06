import Alamofire

public final class AlertService {
    fileprivate let apiUrlString: String
    fileprivate let sessionManager: SessionManager
    
    init(apiUrlString: String, connectTimeoutInSec: TimeInterval = 10) {
        self.apiUrlString = apiUrlString
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = connectTimeoutInSec
        sessionManager = SessionManager(configuration: configuration)
    }
    
    public enum BackendError: Error {
        case network(error: Error) // Capture any underlying Error from the URLSession API
        case jsonSerialization(error: Error)
        case objectConstruction(reason: String)
    }
    
    public class Alert {
        public enum `Type`: String {
            case serviceFailure
            case routineInspection
        }
        
        public let type: Type
        public let id: String
        public let title: String
        public let contents: String
        
        init(rawAlert: [String: Any]) throws {
            guard let type = Type(rawValue: rawAlert["type"] as? String ?? "") else {
                let reason = "Invalid alert type - should be one of the constants from Alert.Type"
                throw BackendError.objectConstruction(reason: reason)
            }
            self.type = type
            id = rawAlert["id"] as? String ?? ""
            title = rawAlert["title"] as? String ?? ""
            contents = rawAlert["contents"] as? String ?? ""
        }
    }
    
    fileprivate class ServiceStatusResponse {
        let alerts: [Alert]
        
        init(data: Data?) throws {
            guard data != nil else {
                throw BackendError.objectConstruction(reason: "Data is null")
            }
            
            let jsonObject: Any
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            } catch {
                throw BackendError.jsonSerialization(error: error)
            }
            
            guard let dictionary = jsonObject as? [String: Any] else {
                throw BackendError.objectConstruction(reason: "Invalid JSON data - should be [String: Any]")
            }
            
            guard let rawAlerts = dictionary["data"] as? [[String: Any]] else {
                throw BackendError.objectConstruction(reason: "No value with the key 'data'")
            }
            
            var tempAlerts = [Alert]()
            for rawAlert in rawAlerts {
                tempAlerts.append(try Alert(rawAlert: rawAlert))
            }
            alerts = tempAlerts
        }
    }
}

extension AlertService {
    func check(success: @escaping ([Alert]) -> Void, error: @escaping (BackendError) -> Void) {
        let deviceVersion = SemVer(versionString: UIDevice.current.systemVersion).normalizedString
        let shortVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "*"
        let appVersion = SemVer(versionString: shortVersionString).normalizedString
        let parameters = ["device_type": "ios", "device_version": deviceVersion, "app_version": appVersion]
        
        sessionManager.request(apiUrlString, method: .get, parameters: parameters)
            .responseJSON(completionHandler: { response in
                if let networkError = response.error {
                    return error(BackendError.network(error: networkError))
                }
                
                do {
                    try success(ServiceStatusResponse(data: response.data).alerts)
                } catch let otherError {
                    error(otherError as! BackendError)
                }
            })
    }
}
