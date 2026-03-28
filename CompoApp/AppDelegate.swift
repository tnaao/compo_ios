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
        let width = ScreenInfo.shared.width
        let height = ScreenInfo.shared.height
        let ratio = width * 1.0 / height
        ScreenInfo.shared.ratio = ratio
        if ScreenInfo.shared.isPortrait {
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
