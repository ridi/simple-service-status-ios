//
//  ServiceStatusAlertChecker.swift
//  Ridibooks
//
//  Created by kgwangrae on 2017. 3. 30..
//  Copyright © 2017년 Ridibooks. All rights reserved.
//

import Alamofire
import SwiftyUserDefaults

public protocol ServiceStatusAlertCheckerDelegate: class {
    /// Called when a new alert is available.
    /// Should return true if the alert is handled, to mark it as handled.
    /// Alerts marked as handled will not invoke this method again.
    func alertCheckerRequiresHandling(of newAlert: AlertService.Alert) -> Bool
    
    func alertCheckerEncountered(_ backendError: AlertService.BackendError)
}

public final class ServiceStatusAlertChecker {
    fileprivate let alertService: AlertService
    
    public weak var delegate: ServiceStatusAlertCheckerDelegate?
    
    fileprivate let checkInterval: TimeInterval
    fileprivate var dispatchCounter = 0
    fileprivate var isRunning = true
    
    fileprivate let handledAlertIdsKey = DefaultsKey<[String]>("simple_notifier_handled_alert_ids")
    fileprivate let handledAlertsHistoryCountLimit: Int
    
    public init(apiUrlString: String, connectTimeoutInSec: TimeInterval = 10, checkInterval: TimeInterval = 30 * 60, handledAlertsHistoryCountLimit: Int = 25) {
        alertService = AlertService(apiUrlString: apiUrlString, connectTimeoutInSec: connectTimeoutInSec)
        self.checkInterval = max(checkInterval, 0.01)
        self.handledAlertsHistoryCountLimit = handledAlertsHistoryCountLimit
    }
}

// MARK: - API checks

public extension ServiceStatusAlertChecker {
    @objc func start() {
        isRunning = true
        check()
    }
    
    @objc func stop() {
        isRunning = false
    }
    
    @objc func check() {
        if !isRunning {
            NSLog("Trying to check after ServiceStatusAlertChecker stopped.")
            return
        }
        
        (dispatchCounter, _) = Int.addWithOverflow(dispatchCounter, 1)
        let currentDispatchCounter = dispatchCounter
        let nextCheckTime = DispatchTime.now() + Double(Int64(checkInterval * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: nextCheckTime) { [weak self] in
            if self?.dispatchCounter == currentDispatchCounter {
                self?.check()
            }
        }
        
        let successHandler = { [weak self] (alerts: [AlertService.Alert]) in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                var handledAlerts = Defaults[strongSelf.handledAlertIdsKey]
                for alert in alerts {
                    if !handledAlerts.contains(alert.id) && (strongSelf.delegate?.alertCheckerRequiresHandling(of: alert) ?? false) {
                        handledAlerts.append(alert.id)
                    }
                }
                let exceedingCapacity = handledAlerts.count - strongSelf.handledAlertsHistoryCountLimit
                if exceedingCapacity > 0 {
                    Defaults[strongSelf.handledAlertIdsKey] = Array(handledAlerts.dropFirst(exceedingCapacity))
                } else {
                    Defaults[strongSelf.handledAlertIdsKey] = handledAlerts
                }
            }
        }
        
        let errorHandler = { [weak self] (error: AlertService.BackendError) -> Void in
            self?.delegate?.alertCheckerEncountered(error)
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { [weak self] in
            self?.alertService.check(with: successHandler, with: errorHandler)
        }
    }
}
