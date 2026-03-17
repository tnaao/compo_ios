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
    @Environment(SimpleRouter<Destination, Sheet>.self) private var router
    @State private  var tabRouter = Router<AppTab, Destination, Sheet>(initialTab: .all)
    @State private var isLoggedIn: Bool = true
    
    var body: some View {
        
        if(!isLoggedIn){
            LoginView()
        }else {
            ZStack {
                // Main content
                Group {
                    switch tabRouter.selectedTab {
                    case .all:
                        GameOnGoingListView()
                    default:
                        ProfileView()
                    }
                }.padding(.top,56.adapter)
                
                VStack {
                    ZStack(alignment: .center, content: {
                        Text("Zswing")
                          .font(Font.custom("DouyinSans", size: 16.adapter))
                          .foregroundColor(.black)
                        Button {
                            
                        } label: {
                            HStack(spacing: 0) {
                                Spacer()
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color(hex: "FF6E5DFF"))
                                    .frame(width: 12.adapter,height: 12.adapter)
                                
                                Text("退出")
                                    .foregroundStyle(Color.init(hex: "#FF3D3D3D"))
                                    .font(.system(size: 12.adapter))
                                    .padding(
                                        EdgeInsets(top: 0, leading: 4.adapter, bottom: 0, trailing: 12.adapter)
                                    )
                                    
                            }
                        }

                    }).frame(height: 22.adapter)
                    HomeTopBar(selectedTab: $tabRouter.selectedTab)
                    Spacer()
                }
            }.loginBg()
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
struct BlankView: View {
  var body: some View {
    Text("开发中")
      .font(.largeTitle)
  }
}

#Preview {
  ContentView()
}
