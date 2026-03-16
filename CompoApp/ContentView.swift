//
//  ContentView.swift
//  CompoApp
//
//  Created by GH w on 3/15/26.
//

import AppRouter
import SwiftUI

struct ContentView: View {
    @State private var router = AppRouter.shared.appRouter
    @State private var isLoggedIn: Bool = AppRouter.shared.isLoggedIn

  var body: some View {
      
      if(!isLoggedIn){
          LoginView().onAppear {
              AppRouter.shared.isLoggedIn = true
          }
      }else {
          ZStack {
            // Main content
            Group {
              switch router.selectedTab {
              case .wakuku:
                HomeView()
              case .personality:
                PersonalityView()
              case .diary:
                DiaryView()
              case .profile:
                ProfileView()
              }
            }.onAppear {
                router.presentSheet(.login)
            }

            // Custom bottom tab bar
            GeometryReader { geometry in
                VStack {
                  Spacer()
                    CustomTabBar(selectedTab: $router.selectedTab,bottom: geometry.safeAreaInsets.bottom)
                }
            }
          }
          .sheet(item: $router.presentedSheet) { sheet in
              AppRouter.shared.sheetView(for: sheet)
          }
        }
      }
    
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
  @Binding var selectedTab: AppTab
  let bottom: CGFloat

  var body: some View {
    HStack(spacing: 0) {
      ForEach(AppTab.allCases) { tab in
        TabBarItem(
          tab: tab,
          isSelected: selectedTab == tab
        ) {
          withAnimation(.easeInOut(duration: 0.2)) {
            selectedTab = tab
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 0)
    .background(
      Color(red: 1.0, green: 0.95, blue: 0.9)
        .ignoresSafeArea(edges: .bottom)
    )
  }
}

// MARK: - Tab Bar Item
struct TabBarItem: View {
  let tab: AppTab
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 4) {
          Image(tab.icon)
              .resizable()
              .scaledToFit()
              .frame(width: 26, height: 26)
          .foregroundColor(isSelected ? .black : .gray)

        Text(tab.title)
          .font(.system(size: 12))
          .foregroundColor(isSelected ? .black : .gray)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical,4)
    }
  }
}

// MARK: - Placeholder Views
struct PersonalityView: View {
  var body: some View {
    Text("性格分析")
      .font(.largeTitle)
  }
}

struct DiaryView: View {
  var body: some View {
    Text("心事日历")
      .font(.largeTitle)
  }
}

struct ProfileView: View {
  var body: some View {
    Text("我的")
      .font(.largeTitle)
  }
}

#Preview {
  ContentView()
}
