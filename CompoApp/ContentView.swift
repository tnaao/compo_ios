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
    @Environment(\.appRouter) private var router
    @StateObject private var vm = ContentVm()
    @State private var selectedTab = AppTab.all
    
    @StateObject private var scoreStore = MatchScoringStore.shared
    
    @State var isRefreshing = false
    @Environment(\.safeAreaInsets) var safeAreaInsets
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear.ignoresSafeArea()
            VStack() {
                HomeHeaderView {
                    //退出登录
                    UserInfo.shared.clear()
                    if !UserInfo.shared.isLogin {
                        AppRouter.shared.appRouter.navigateTo(.login)
                    }
                }.padding(.top,safeAreaInsets.top)
                //HomeTopBar
                HomeTopBar(selectedTab: $selectedTab)
                // Main content
                SwipeToRefreshListView(vm.matches, isRefreshing: $vm.isRefreshing, spacing: 6.verticaldapter) { idx, item in
                    if idx == 0 {
                        Spacer().fixedSize().frame(height: 3.verticaldapter)
                    }
                    Button {
                        scoreStore.currentEvent = item
                        router.navigateTo(.gamedetailHome)
                    } label: {
                        GameCard(match: item).padding(.horizontal,12.verticaldapter)
                    }.noClickEffect()
                }.onRefresh {
                    vm.refresh(selectedTab: selectedTab)
                }
            }
            
        }.onAppear {
            vm.refresh(selectedTab: selectedTab)
        }
        .onChange(of: selectedTab) { newValue in
            vm.refresh(selectedTab: newValue)
        }
        .loginBg().enableInjection()
    }
    
    @ObserveInjection var inject
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
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
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
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// MARK: - Placeholder Views
struct PersonalityView: View {
  var body: some View {
    Text("性格分析")
      .font(.largeTitle)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

struct DiaryView: View {
  var body: some View {
    Text("心事日历")
      .font(.largeTitle)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

struct ProfileView: View {
  var body: some View {
    Text("我的")
      .font(.largeTitle)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}
struct BlankView: View {
  var body: some View {
    Text("开发中")
      .font(.largeTitle)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

#Preview {
    RootView(rootDestination: .launch)
}
