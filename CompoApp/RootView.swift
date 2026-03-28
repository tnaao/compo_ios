//
//  RootView.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//

import SwiftUI
import AppRouter
import AdapterSwift

struct RootView: View {
    var rootDestination: Destination = .launch
    @StateObject private var screenInfo = ScreenInfo.shared
    @State var safeAreaInsets: EdgeInsets = ScreenInfo.shared.safeAreaInsets
    @StateObject private var router = AppRouter.shared.appRouter
    var body: some View {
        ZStack {
            NavigationView {
            }.getSafeAreaInsets($safeAreaInsets)
              .onAppear {
                ScreenInfo.shared.safeAreaInsets = safeAreaInsets
                AppRouter.shared.appRouter = router
              }
             NavigationStack(path: $router.path) {
                 ZStack {
                     Text("\(safeAreaInsets.top)")
                 }.navigationDestination(for: Destination.self) { destination in
                     AppRouter.shared.destinationView(for: destination)
                 }.onChange(of: router.path, perform: {  newValue in
                     if router.path.isEmpty {
                         router.navigateTo(.launch)
                     }
                 })
            }.sheet(item: $router.presentedSheet) { sheet in
                        AppRouter.shared.sheetView(for: sheet)
                    }.environment(\.appRouter, router)
                    .environment(\.safeAreaInsets, screenInfo.safeAreaInsets)
                    .onAppear {
                        AppRouter.shared.appRouter = router
                        if(router.path.isEmpty || rootDestination != router.path.last){
                            router.navigateTo(rootDestination)
                        }
                    }
        }.onChange(of: screenInfo.orientation) { newValue in
            if newValue.isPortrait {
                Adapter.share.mode = .width
                Adapter.share.base = ScreenInfo.shared.baseW
                Verticaldapter.share.base = ScreenInfo.shared.baseW
                Verticaldapter.share.mode = .width
                let path = router.path.last
                guard let path = path else {
                    return
                }
                router.popToRoot()
                router.path.append(path)
            }else {
                Adapter.share.mode = .height
                Adapter.share.base = ScreenInfo.shared.baseH
                Verticaldapter.share.base = ScreenInfo.shared.baseH
                Verticaldapter.share.mode = .height
                let path = router.path.last
                guard let path = path else {
                    return
                }
                router.popToRoot()
                router.path.append(path)
            }
        }
    }
}
