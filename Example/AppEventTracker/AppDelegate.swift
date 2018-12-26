//
//  AppDelegate.swift
//  AppEventTracker
//
//  Created by diamantidis on 12/16/2018.
//  Copyright (c) 2018 diamantidis. All rights reserved.
//

import AppEventTracker
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // To avoid loading the following code when running unit tests
        if ProcessInfo.processInfo.environment["XCInjectBundleInto"] == nil {
            AppEventTracker.configure(size: 10) {eventType, selector in
                print("eventType: \(eventType)")
                print("selector: \(selector.debugDescription)")
            }
            AppEventTracker.enableViewDidLoad()
            AppEventTracker.enableDidReceiveMemoryWarning()
            AppEventTracker.enableUIButtonSendAction()
        }

        return true
    }
}
