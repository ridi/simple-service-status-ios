//
//  AppDelegate.swift
//  SimpleNotifier-Demo
//
//  Created by kgwangrae on 2017. 3. 30..
//  Copyright © 2017년 Ridibooks. All rights reserved.
//

import UIKit
import SimpleNotifier

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    static let serviceStatusAlertChecker = ServiceStatusAlertChecker(apiUrl: "http://your.url/here", checkInterval: 5, handledAlertsHistoryCountLimit: 3)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.serviceStatusAlertChecker.start()
        return true
    }
}
