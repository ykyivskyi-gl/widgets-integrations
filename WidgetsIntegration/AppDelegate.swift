//
//  AppDelegate.swift
//  WidgetsIntegration
//
//  Created by Yevhen Kyivskyi on 13/09/2024.
//

import GliaWidgets
import GliaCoreSDK
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {

    private let gliaCoreAppDelegate = GliaCoreAppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        gliaCoreAppDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        GliaCore.sharedInstance.pushNotifications.application(
            application,
            didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
        )
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        gliaCoreAppDelegate.applicationDidBecomeActive(application)
    }
}
