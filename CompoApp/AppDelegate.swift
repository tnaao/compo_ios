//
//  AppDelegate.swift
//  CompoApp
//
//  Created by GH w on 3/16/26.
//
import SwiftUI
import AdapterSwift
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Adapter.share.base = 683
        Verticaldapter.share.base = UIScreen.main.bounds.size.height
        print("did finish launch")
        return true
    }
}
