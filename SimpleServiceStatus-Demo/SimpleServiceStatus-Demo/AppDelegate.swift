import UIKit
import SimpleServiceStatus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    /// Checks every minute
    static let serviceStatusAlertChecker = ServiceStatusAlertChecker(apiUrlString: "http://localhost:8080/api/v1/status/check", checkInterval: 60, handledAlertsHistoryCountLimit: 3)

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Checks when the application enters foreground
        NotificationCenter.default.addObserver(AppDelegate.serviceStatusAlertChecker, selector: #selector(AppDelegate.serviceStatusAlertChecker.check), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        AppDelegate.serviceStatusAlertChecker.start()
        return true
    }
}
