//
//  RootView.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//

import SwiftUI
import AppRouter

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
                                    ContentView()
                                        .navigationDestination(for: Destination.self) { destination in
                                            AppRouter.shared.destinationView(for: destination)
                                        }
                                }
                        .navigationDestination(for: Destination.self) { destination in
                          AppRouter.shared.destinationView(for: destination)
                        }
                    .sheet(item: $router.presentedSheet) { sheet in
                        AppRouter.shared.sheetView(for: sheet)
                    }.environment(\.appRouter, router)
                    .environment(\.safeAreaInsets, screenInfo.safeAreaInsets)
                    .onAppear {
                        if(rootDestination != .launch){
                            router.navigateTo(rootDestination)
                        }
                    }
        }
    }
}
