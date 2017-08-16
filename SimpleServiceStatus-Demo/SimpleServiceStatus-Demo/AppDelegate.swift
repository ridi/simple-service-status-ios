//
//  AppDelegate.swift
//  SimpleServiceStatus-Demo
//
//  Created by kgwangrae on 2017. 3. 30..
//  Copyright © 2017년 Ridibooks. All rights reserved.
//

import UIKit
import SimpleServiceStatus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    /// Checks every minute
    static let serviceStatusAlertChecker = ServiceStatusAlertChecker(apiUrlString: "http://localhost:8080/api/v1/status/check", checkInterval: 60, handledAlertsHistoryCountLimit: 3)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /// Checks when the application enters foreground
        NotificationCenter.default.addObserver(AppDelegate.serviceStatusAlertChecker, selector: #selector(AppDelegate.serviceStatusAlertChecker.check), name: .UIApplicationWillEnterForeground, object: nil)
        
        AppDelegate.serviceStatusAlertChecker.start()
        return true
    }
}
