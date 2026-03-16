//
//  ContentView.swift
//  CompoApp
//
//  Created by GH w on 3/15/26.
//

import AppRouter
import SwiftUI
import AdapterSwift

struct ContentView: View {
    @State private var appRouter = AppRouter.shared
    @State private var router:Router<AppTab, Destination, Sheet> = AppRouter.shared.appRouter
    @State private var isLoggedIn: Bool = true
    
    var body: some View {
        
        if(!isLoggedIn){
            LoginView()
        }else {
            ZStack {
                // Main content
                Group {
                    switch router.selectedTab {
                    case .all:
                        let a = $router[.all]
                        HomeView()
                    default:
                        ProfileView()
                    }
                }.padding(.top,56.adapter)
                .sheet(item: $router.presentedSheet) { sheet in
                    AppRouter.shared.sheetView(for: sheet)
                }
                
                VStack {
                    HStack(spacing: 0) {
                        
                    }.frame(height: 22.adapter)
                    HomeTopBar(selectedTab: $router.selectedTab)
                    Spacer()
                }
            }
        }
        
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
  @Binding var selectedTab: AppTab

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
