//
//  ReachabilityManager.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 31/03/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import Foundation
import UIKit

class ReachabilityManager {

    static let sharedInstance = ReachabilityManager()
    private var internetReachability: Reachability
    private var isNetAvailable = true

    private init() {
        internetReachability = Reachability.forInternetConnection()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(_:)),
                                               name: NSNotification.Name.reachabilityChanged,
                                               object: nil)
        internetReachability.startNotifier()
        self.updateInterfaceWithReachability(internetReachability)
    }

    @objc func reachabilityChanged(_ notification: Notification) {

        if let curReach = notification.object as? Reachability {
            self.updateInterfaceWithReachability(curReach)
        }
    }

    func updateInterfaceWithReachability(_ reachability: Reachability) {

        isNetAvailable = true
        let netStatus = reachability.currentReachabilityStatus()
        //var connectionRequired = reachability.connectionRequired()
        switch netStatus {
        case NotReachable:
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            isNetAvailable = false
        case ReachableViaWWAN:
            break
        case ReachableViaWiFi:
            break
        default:
            break
        }
        let userInfo = ["status": isNetAvailable]
        printDebug("send status notification")
        NotificationCenter.default.post(name: .networkAvailability, object: nil, userInfo: userInfo)
    }

    /**
     Returns network available or not
     
     - returns: status of network availability
     */
    func isReachable() -> Bool {

        return isNetAvailable
    }
}
