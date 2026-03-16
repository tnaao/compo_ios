//
//  HomeTopBar.swift
//  CompoApp
//
//  Created by GH w on 3/16/26.
//

import SwiftUI
import AdapterSwift

struct HomeTopBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
              ForEach(AppTab.allCases) { tab in
                  HomeTopBarItem(
                  tab: tab,
                  tabW:geometry.size.width / 3,
                  isSelected: selectedTab == tab
                ) {
                  withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = tab
                  }
                }
              }
            }
            .background(
                Color.clear
            )
        }.padding(.horizontal,12.adapter)
    }
}

//mark HomeTopBarItem
struct HomeTopBarItem: View {
  let tab: AppTab
  let tabW:Double
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      ZStack(alignment: .center) {
        Text(tab.title)
              .font(.system(size: 12.adapter))
          .foregroundColor(isSelected ? Color(hex: "#FF222429") : Color(hex: "#FF848A98"))
        
          VStack {
              Spacer()
              if isSelected {
                  Spacer().frame(
                    width: tabW,
                    height: 1.adapter
                  )
                      .background(Color(hex: "#FF6E5DFF"))
              }
          }
      }
      .frame(height: 22.adapter)
      .frame(maxWidth: .infinity,maxHeight: 22.adapter)
      .padding(.top,11.adapter)
    }
  }
}

#Preview {
  ContentView()
}
