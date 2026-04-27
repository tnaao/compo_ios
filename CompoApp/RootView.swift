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
                    .environment(\.isLandscape, screenInfo.isLandscape)
                    .onAppear {
                        AppRouter.shared.appRouter = router
                        if router.path.isEmpty {
                            router.navigateTo(rootDestination)
                        }
                        updateAdapters(ratio: screenInfo.ratio)
                    }
        }.onChange(of: screenInfo.ratio) { newValue in
            updateAdapters(ratio: newValue)
        }
        .id(screenInfo.ratio) // Force full view re-render when ratio changes
        .enableInjection()
    }
    
    private func updateAdapters(ratio: Double) {
        if ratio > 1 {
            // Landscape logic
            Adapter.share.mode = .width
            Adapter.share.base = screenInfo.baseW
            Verticaldapter.share.mode = .width
            Verticaldapter.share.base = screenInfo.baseW
        } else {
            // Portrait logic
            Adapter.share.mode = .height
            Adapter.share.base = screenInfo.baseH
            Verticaldapter.share.mode = .height
            Verticaldapter.share.base = screenInfo.baseH
        }
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}
