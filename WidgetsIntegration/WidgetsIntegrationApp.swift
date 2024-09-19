//
//  WidgetsIntegrationApp.swift
//  WidgetsIntegration
//
//  Created by Yevhen Kyivskyi on 13/09/2024.
//

import SwiftUI

@main
struct WidgetsIntegrationApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
