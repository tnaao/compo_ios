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
    let tabList = [AppTab.all,AppTab.ongoing,AppTab.finished]

    var body: some View {
        HStack(spacing: 0) {
          ForEach(tabList) { tab in
              HomeTopBarItem(
              tab: tab,
              tabW: 0,
              isSelected: selectedTab == tab
            ) {
              withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
              }
            }
          }
        }
        .padding(.horizontal,12.adapter)
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
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
                    height: 1.adapter
                  ).frame(maxWidth: tabW > 0 ? tabW : .infinity)
                      .background(Color.colorPrimary)
              }
          }
      }
      .frame(height: 22.adapter)
      .frame(maxWidth: .infinity)
      .padding(.top,11.adapter)
      .background(Color.clickColor)
    }.noClickEffect()
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

struct HomeTopBar_PreviewView :View {
    @State var selTab:AppTab = .all
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear.ignoresSafeArea()
            HomeTopBar(selectedTab: $selTab)
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

@available(iOS 17.0, *)
#Preview {
    HomeTopBar_PreviewView()
}
