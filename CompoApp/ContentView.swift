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
    @State private  var selectedTab = AppTab.all
    
    let matches = [
        MatchModel(
            title: "2025年VICTOR萧山区第六届青少年羽毛球冠军赛1",
            dateTime: "2025-12-20 9:00至18:00",
            location: "杭州市萧山区体育馆",
            status: .ongoing,
            imageName: "match_badminton_1"
        ),
        MatchModel(
            title: "2025年VICTOR萧山区第六届青少年羽毛球冠军赛2",
            dateTime: "2025-12-20 9:00至18:00",
            location: "杭州市萧山区体育馆",
            status: .completed,
            imageName: "match_badminton_2"
        ),
        MatchModel(
            title: "2025年VICTOR萧山区第六届青少年羽毛球冠军赛3",
            dateTime: "2025-12-20 9:00至18:00",
            location: "杭州市萧山区体育馆",
            status: .completed,
            imageName: "match_badminton_2"
        ),
        MatchModel(
            title: "2025年VICTOR萧山区第六届青少年羽毛球冠军赛4",
            dateTime: "2025-12-20 9:00至18:00",
            location: "杭州市萧山区体育馆",
            status: .completed,
            imageName: "match_badminton_2"
        ),
    ]
    @State var isRefreshing = false
    @Environment(\.safeAreaInsets) var safeAreaInsets
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear.ignoresSafeArea()
            VStack() {
                HomeHeaderView {
                    //退出登录
                }.padding(.top,safeAreaInsets.top)
                //HomeTopBar
                HomeTopBar(selectedTab: $selectedTab)
                // Main content
                SwipeToRefreshListView(matches, isRefreshing: $isRefreshing,spacing: 6.verticaldapter) { idx, item in
                    if idx == 0 {
                        Spacer().fixedSize().frame(height: 3.verticaldapter)
                    }
                    Button {
                        router.navigateTo(.gamedetailHome)
                    } label: {
                        GameCard(match: item).padding(.horizontal,12.verticaldapter)
                    }
                }.onRefresh {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                        isRefreshing = false
                    })
                }
            }
            
        }.loginBg()
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
struct BlankView: View {
  var body: some View {
    Text("开发中")
      .font(.largeTitle)
  }
}

#Preview {
    RootView(rootDestination: .launch)
}
