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
        ScreenInfo.shared.calculateRatio()
        if ScreenInfo.shared.ratio > 1 {
            Adapter.share.mode = .width
            Adapter.share.base = ScreenInfo.shared.baseW
            Verticaldapter.share.base = ScreenInfo.shared.baseW
            Verticaldapter.share.mode = .width
        }else {
            Adapter.share.mode = .height
            Adapter.share.base = ScreenInfo.shared.baseH
            Verticaldapter.share.base = ScreenInfo.shared.baseH
            Verticaldapter.share.mode = .height
        }
        print("did finish launch")
        return true
    }
}
