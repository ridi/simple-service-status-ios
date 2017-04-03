//
//  AlertService.swift
//  Ridibooks
//
//  Created by kgwangrae on 2017. 3. 30..
//  Copyright © 2017년 Ridibooks. All rights reserved.
//

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
    
    public class Alert {
        public enum `Type`: String {
            case serviceFailure
            case routineInspection
        }
        
        public let type: Type
        public let id: String
        public let title: String
        public let contents: String
        
        init?(rawAlert: [String: Any]) {
            guard let type = Type(rawValue: rawAlert["type"] as? String ?? "") else {
                NSLog("Invalid alert type - should be one of the constants from Alert.Type")
                return nil
            }
            self.type = type
            id = rawAlert["id"] as? String ?? ""
            title = rawAlert["title"] as? String ?? ""
            contents = rawAlert["contents"] as? String ?? ""
        }
    }
    
    class ServiceStatusResponse {
        let alerts: [Alert]
        
        init?(data: Data) {
            guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any] else {
                NSLog("Invalid JSON data - should be [String: Any]")
                return nil
            }
            
            guard let rawAlerts = dictionary["data"] as? [[String: Any]] else {
                NSLog("No value with the key 'data'")
                return nil
            }
            
            var tempAlerts = [Alert]()
            for rawAlert in rawAlerts {
                if let alert = Alert(rawAlert: rawAlert) {
                    tempAlerts.append(alert)
                }
            }
            alerts = tempAlerts
        }
    }
}

extension AlertService {
    func check(with completion: @escaping (ServiceStatusResponse?) -> Void) {
        let deviceVersion = SemVer(versionString: UIDevice.current.systemVersion).normalizedString
        let appVersion = SemVer(versionString: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "*").normalizedString
        let parameters = ["device_type": "ios", "device_version": deviceVersion, "app_version": appVersion]
        
        sessionManager.request(apiUrlString, method: .get, parameters: parameters).responseJSON(completionHandler: { response in
            if let error = response.error {
                NSLog(error.localizedDescription)
                return completion(nil)
            }
            if let data = response.data {
                return completion(ServiceStatusResponse(data: data))
            }
            completion(nil)
        })
    }
}
