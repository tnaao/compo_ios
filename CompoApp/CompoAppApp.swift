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
    @Bindable private var appRouter = AppRouter.shared
    @State private var router = AppRouter.shared.appRouter
    
    var body: some Scene {
        WindowGroup {
            RootView(router: $router)
                .environment(appRouter)
        }
    }
}
