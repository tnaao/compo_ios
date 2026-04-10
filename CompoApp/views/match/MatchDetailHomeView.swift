//
//  GameDetailHomeView.swift
//  CompoApp
//
//  Created by Qoder on 3/17/26.
//

import AdapterSwift
import SwiftUI

// MARK: - Game Detail Tab
enum GameDetailTab: String, CaseIterable, Identifiable {
  case ongoing = "进行中"
  case finished = "已结束"

  var id: String { rawValue }

  func title(count: Int) -> String {
    return "\(rawValue)（\(count)）"
  }
}

struct PlayerInfo {
  let name: String
  let team: String
  let avatarName: String
  let hasWinnerBadge: Bool
}

// MARK: - Game Detail Home View
struct GameDetailHomeView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var selectedTab: GameDetailTab = .finished

  let title: String = "2025年萧山区第六届乒乓球冠军赛"
  let ongoingCount: Int = 10
  let finishedCount: Int = 6

  let matches: [MatchModel1] = [
    MatchModel1(
      court: "场地8",
      matchNumber: "第13场",
      matchInfo: "小学E组男子双打 8进4 [XEMS218]",
      team1: [PlayerModel(name: "李泽凡", hasCrown: true), PlayerModel(name: "余飞", hasCrown: true)],
      team2: [PlayerModel(name: "马言", hasCrown: false), PlayerModel(name: "陈苇航", hasCrown: false)],
      scoreTeam1: 2,
      scoreTeam2: 0,
      courtChange: nil
    ),
    MatchModel1(
      court: "场地2",
      matchNumber: "第13场",
      matchInfo: "小学E组男子双打 8进4 [XEMS218]",
      team1: [PlayerModel(name: "李泽凡", hasCrown: true), PlayerModel(name: "余飞", hasCrown: true)],
      team2: [PlayerModel(name: "马言", hasCrown: false), PlayerModel(name: "陈苇航", hasCrown: false)],
      scoreTeam1: 2,
      scoreTeam2: 0,
      courtChange: nil
    ),
    MatchModel1(
      court: "场地3",
      matchNumber: "第13场",
      matchInfo: "小学E组男子双打 8进4 [XEMS218]",
      team1: [PlayerModel(name: "李泽凡", hasCrown: true), PlayerModel(name: "余飞", hasCrown: true)],
      team2: [PlayerModel(name: "马言", hasCrown: false), PlayerModel(name: "陈苇航", hasCrown: false)],
      scoreTeam1: 2,
      scoreTeam2: 0,
      courtChange: nil
    ),
  ]

  var body: some View {
      ZStack(alignment: .topLeading) {
      // Background
      Color(hex: "#FFF5F6FA")
        .ignoresSafeArea()

      VStack(spacing: 0) {
        // Navigation Bar
        navigationBar

        // Tab Selector
        gameDetailTabBar
          .frame(height: 27.adapter)

        // Match List
        ScrollView {
          LazyVStack(spacing: 12.adapter) {
            ForEach(matches) { match in
                if selectedTab == .ongoing {
                    MatchCardMultiGoingView(match: match)
                    MatchCardSingleGoingView(match: .sample)
                }else{
                    MatchCardMultiView(match: match)
                    MatchCardSingleView(match: .sampleWithCourtChange)
                }
            }
          }
          .padding(.horizontal, 12.adapter)
          .padding(.top, 12.adapter)
          .padding(.bottom, 20.adapter)
        }
      }
    }
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif

  // MARK: - Navigation Bar
  private var navigationBar: some View {
    HStack(spacing: 0.adapter) {
        LeadingBtn{
            dismiss()
        }

      Text(title)
        .font(.system(size: 10.adapter, weight: .medium))
        .foregroundColor(Color(hex: "#FF222429"))

      Spacer()
    }
    .padding(.trailing, 16.adapter)
    .frame(height: 25.verticaldapter)
    .background(Color.white)
  }

  // MARK: - Tab Bar
  private var gameDetailTabBar: some View {
    GeometryReader { geometry in
      HStack(spacing: 0) {
        ForEach(GameDetailTab.allCases) { tab in
          GameDetailTabItem(
            tab: tab,
            count: tab == .ongoing ? ongoingCount : finishedCount,
            tabW: geometry.size.width / 2,
            isSelected: selectedTab == tab
          ) {
            withAnimation(.easeInOut(duration: 0.2)) {
              selectedTab = tab
            }
          }
        }
      }
      .background(Color.white)
    }
  }
}

// MARK: - Game Detail Tab Item
struct GameDetailTabItem: View {
  let tab: GameDetailTab
  let count: Int
  let tabW: Double
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      ZStack(alignment: .center) {
        Text(tab.title(count: count))
              .font(.system(size: 12.adapter, weight: isSelected ? .medium : .regular))
          .foregroundColor(isSelected ? Color(hex: "#FF6E5DFF") : Color(hex: "#FF848A98"))

        VStack {
          Spacer()
          if isSelected {
            Rectangle()
              .fill(Color(hex: "#FF6E5DFF"))
              .frame(width: 60.adapter, height: 2.adapter)
          }
        }
      }
      .frame(height: 27.adapter)
      .frame(maxWidth: .infinity)
      .background(Color.clickColor)
    }.noClickEffect()
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif

}

#Preview {
    RootView(rootDestination: .gamedetailHome, )
}
