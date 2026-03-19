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
    @State private var router = AppRouter.shared.appRouter
    var body: some View {
        NavigationStack(path: $router.path) {
                    ContentView()
                        .navigationDestination(for: Destination.self) { destination in
                            AppRouter.shared.destinationView(for: destination)
                        }
                }
                .sheet(item: $router.presentedSheet) { sheet in
                    AppRouter.shared.sheetView(for: sheet)
                }.environment(router).onAppear {
                    if(rootDestination != .launch){
                        router.navigateTo(rootDestination)
                    }
                }
    }
}
