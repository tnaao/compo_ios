//
//  CompoAppApp.swift
//  CompoApp
//
//  Created by GH w on 3/15/26.
//

import SwiftUI
import AppRouter

@main
struct CompoAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView(rootDestination: .launch)
        }
    }
}
