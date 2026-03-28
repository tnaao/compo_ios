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

// MARK: - Match Info Model
struct MatchInfo: Identifiable {
  let id = UUID()
  let venue: String
  let matchNumber: String
  let category: String
  let matchCode: String
  let player1: PlayerInfo
  let player2: PlayerInfo
  let score1: Int
  let score2: Int
  let venueSwap: String?
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

  let matches: [MatchInfo] = [
    MatchInfo(
      venue: "场地8",
      matchNumber: "第13场",
      category: "小学E组男子单打 8进4",
      matchCode: "XEMS218",
      player1: PlayerInfo(name: "余苇航", team: "原创体育", avatarName: "avatar1", hasWinnerBadge: true),
      player2: PlayerInfo(name: "郑泽言", team: "萧山羽飞", avatarName: "avatar2", hasWinnerBadge: false),
      score1: 21,
      score2: 19,
      venueSwap: nil
    ),
    MatchInfo(
      venue: "场地7",
      matchNumber: "第14场",
      category: "小学E组女子单打 8进4",
      matchCode: "XEWS205",
      player1: PlayerInfo(name: "吴苇航", team: "原创体育", avatarName: "avatar1", hasWinnerBadge: false),
      player2: PlayerInfo(name: "郑泽然", team: "萧山羽飞", avatarName: "avatar2", hasWinnerBadge: false),
      score1: 17,
      score2: 21,
      venueSwap: "场地7 换 场地8"
    ),
    MatchInfo(
      venue: "场地8",
      matchNumber: "第14场",
      category: "小学E组女子单打 8进4",
      matchCode: "XEWS206",
      player1: PlayerInfo(name: "陈苇", team: "个人", avatarName: "avatar1", hasWinnerBadge: false),
      player2: PlayerInfo(name: "黄泽言", team: "萧山羽飞", avatarName: "avatar2", hasWinnerBadge: false),
      score1: 18,
      score2: 21,
      venueSwap: nil
    ),
    MatchInfo(
      venue: "场地7",
      matchNumber: "13:00",
      category: "高中组男子单打6组",
      matchCode: "GMS6",
      player1: PlayerInfo(name: "余苇航", team: "原创体育", avatarName: "avatar1", hasWinnerBadge: true),
      player2: PlayerInfo(name: "郑泽言", team: "萧山羽飞", avatarName: "avatar2", hasWinnerBadge: false),
      score1: 21,
      score2: 11,
      venueSwap: nil
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
          .frame(height: 44.adapter)

        // Match List
        ScrollView {
          LazyVStack(spacing: 12.adapter) {
            ForEach(matches) { match in
              MatchDetailCard(match: match)
            }
          }
          .padding(.horizontal, 16.adapter)
          .padding(.top, 12.adapter)
          .padding(.bottom, 20.adapter)
        }
      }
    }
  }

  // MARK: - Navigation Bar
  private var navigationBar: some View {
    HStack(spacing: 12.adapter) {
      Button(action: {
        dismiss()
      }) {
        Image(systemName: "chevron.left")
          .font(.system(size: 18.adapter, weight: .medium))
          .foregroundColor(Color(hex: "#FF222429"))
      }

      Text(title)
        .font(.system(size: 16.adapter, weight: .medium))
        .foregroundColor(Color(hex: "#FF222429"))

      Spacer()
    }
    .padding(.horizontal, 16.adapter)
    .padding(.vertical, 12.adapter)
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
          .font(.system(size: 14.adapter, weight: isSelected ? .medium : .regular))
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
      .frame(height: 44.adapter)
      .frame(maxWidth: .infinity)
    }
  }
}

// MARK: - Match Detail Card
struct MatchDetailCard: View {
  let match: MatchInfo

  var body: some View {
    VStack(alignment: .leading, spacing: 12.adapter) {
      // Header
      HStack(spacing: 4.adapter) {
        Text(match.venue)
          .font(.system(size: 14.adapter, weight: .medium))
          .foregroundColor(Color(hex: "#FFFF7F23"))

        Text("｜")
          .font(.system(size: 14.adapter))
          .foregroundColor(Color(hex: "#FF6E5DFF"))

        Text(match.matchNumber)
          .font(.system(size: 14.adapter, weight: .bold))
          .foregroundColor(Color(hex: "#FF5E66FF"))

        Text("（\(match.category) [\(match.matchCode)]）")
          .font(.system(size: 12.adapter))
          .foregroundColor(Color(hex: "#FF848A98"))
      }

      // Players and Score
      HStack(spacing: 0) {
        // Player 1
        playerView(player: match.player1, score: match.score1)

        Spacer()

        // VS Section
          VStack {
              vsSection
                // Venue Swap (if exists)
                if let swap = match.venueSwap {
                  HStack {
                    Spacer()
                    venueSwapView(text: swap)
                    Spacer()
                  }
                  .offset(y:8.adapter)
                }
          }

        Spacer()

        // Player 2
        playerView(player: match.player2, score: match.score2)

          Spacer().fixedSize().frame(width: 135.adapter)

        // Action Buttons
        actionButtons
      }

      
    }
    .padding(16.adapter)
    .background(Color.white)
    .cornerRadius(12.adapter)
  }

  // MARK: - Player View
  private func playerView(player: PlayerInfo, score: Int) -> some View {
      VStack(alignment: .leading,spacing: 8.adapter) {
      HStack(alignment: .center, spacing: 12.adapter) {
        // Avatar with badge
        PlayerIconView(url: nil, hasWinnerBadge: player.hasWinnerBadge).frame(width: 80.adapter)

        // Score
        Text("\(score)")
          .font(.system(size: 24.adapter, weight: .bold))
          .foregroundColor(Color(hex: "#FF222429"))
          .padding(.leading,10.adapter)
      }

      // Player name and team
      Text("\(player.name)【\(player.team)】")
              .font(.system(size: 8.5.adapter))
        .foregroundColor(Color(hex: "#FF848A98"))
        .frame(width: 80.adapter)
    }
  }

  // MARK: - VS Section
  private var vsSection: some View {
    MyAssetImage(name: "vs",width: 27.adapter,height: 40.adapter)
  }

  // MARK: - Action Buttons
  private var actionButtons: some View {
    VStack(spacing: 8.adapter) {
      Button(action: {
        // Re-sign action
      }) {
        Text("重新签名")
          .font(.system(size: 13.adapter, weight: .medium))
          .foregroundColor(.white)
          .frame(width: 90.adapter, height: 36.adapter)
          .background(Color(hex: "#FF6E5DFF"))
          .cornerRadius(18.adapter)
      }

      Button(action: {
        // Enter result action
      }) {
        Text("录入结果")
          .font(.system(size: 13.adapter, weight: .medium))
          .foregroundColor(Color(hex: "#FF6E5DFF"))
          .frame(width: 90.adapter, height: 36.adapter)
          .background(Color.white)
          .overlay(
            RoundedRectangle(cornerRadius: 18.adapter)
              .stroke(Color(hex: "#FF6E5DFF"), lineWidth: 1)
          )
          .cornerRadius(18.adapter)
      }
    }
  }

  // MARK: - Venue Swap View
  private func venueSwapView(text: String) -> some View {
    HStack(spacing: 4.adapter) {
      let parts = text.components(separatedBy: " 换 ")
      if parts.count == 2 {
        Text(parts[0])
          .font(.system(size: 12.adapter))
          .foregroundColor(Color(hex: "#FF848A98"))

        ZStack {
          Circle()
            .fill(Color(hex: "#FFFFC107"))
            .frame(width: 20.adapter, height: 20.adapter)

          Text("换")
            .font(.system(size: 10.adapter, weight: .medium))
            .foregroundColor(.white)
        }

        Text(parts[1])
          .font(.system(size: 12.adapter))
          .foregroundColor(Color(hex: "#FF848A98"))
      }
    }
  }
}

#Preview {
    RootView(rootDestination: .gamedetailHome, )
}
