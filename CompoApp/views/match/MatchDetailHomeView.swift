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

  func title(count: Int64) -> String {
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
  @State private var selectedTab: GameDetailTab = .ongoing
  @StateObject private var scoreStore:MatchScoringStore = MatchScoringStore.shared
  @StateObject private var viewModel = GameDetailHomeVm()
    
  @State private var isShowInputResult: Bool = false
  @State private var isShowMessagePopup: Bool = false
  @State private var messageReason: String = ""
  @State private var messageContent: String = ""
  @State private var currentMatchNo: String = ""

  var body: some View {
      ZStack(alignment: .topLeading) {
      // Background
      Color(hex: "#FFF5F6FA")
        .ignoresSafeArea()
          
          Color.clear

      VStack(spacing: 0) {
        // Navigation Bar
        navigationBar

        // Tab Selector
        gameDetailTabBar
          .frame(height: 27.adapter)

        // Match List
        SwipeToRefreshListView(viewModel.matches, isRefreshing: $viewModel.isRefreshing, spacing: 12.adapter) { idx, match in
            if idx == 0 {
                Spacer().fixedSize().frame(height: 12.adapter)
            }
            
            Group {
                if selectedTab == .ongoing {
                    if match.isSingle {
                        MatchCardSingleGoingView(match: match.toMatchModelSingle,scoring: {
                            scoreStore.currentMatch = match
                            AppRouter.shared.appRouter.navigateTo(.matchScoring(id: ""))
                        },notifyFn: {
                            currentMatchNo = match.matchNo ?? ""
                            isShowMessagePopup = true
                        }) {
                            scoreStore.currentMatch = match
                            scoreStore.fetchMatchScoreDetail(matchNo: match.matchNo ?? "")
                            isShowInputResult = true
                        }
                    } else {
                        MatchCardMultiGoingView(match: match.toMatchModel1,
                                                scoring: {
                            scoreStore.currentMatch = match
                            AppRouter.shared.appRouter.navigateTo(.matchScoring(id: ""))
                        },notifyFn: {
                            currentMatchNo = match.matchNo ?? ""
                            isShowMessagePopup = true
                        },inputResult:  {
                            scoreStore.currentMatch = match
                            scoreStore.fetchMatchScoreDetail(matchNo: match.matchNo ?? "")
                            isShowInputResult = true
                        })
                    }
                } else {
                    if match.isSingle {
                        MatchCardSingleView(match: match.toMatchModelSingle,resign: {
                            scoreStore.currentMatch = match
                            AppRouter.shared.appRouter.navigateTo(.matchSignatureConfirm)
                        },inputResult: {
                            scoreStore.currentMatch = match
                            scoreStore.fetchMatchScoreDetail(matchNo: match.matchNo ?? "")
                            isShowInputResult = true
                        })
                    } else {
                        MatchCardMultiView(match: match.toMatchModel1,resign: {
                            scoreStore.currentMatch = match
                            AppRouter.shared.appRouter.navigateTo(.matchSignatureConfirm)
                        },inputResult: {
                            scoreStore.currentMatch = match
                            scoreStore.fetchMatchScoreDetail(matchNo: match.matchNo ?? "")
                            isShowInputResult = true
                        })
                    }
                }
            }
            .padding(.horizontal, 12.adapter)
            
            if idx == viewModel.matches.count - 1 {
                Spacer().fixedSize().frame(height: 20.adapter)
            }
        }
        .onRefresh {
            viewModel.refresh(selectedTab: selectedTab)
        }
      }
        
      if isShowInputResult, let currentMatch = scoreStore.currentMatch {
          DoubleMatchResultEntryView(
              onCancel: {
                  isShowInputResult = false
              },
              onConfirm: { scores in
                  isShowInputResult = false
                  submitScores(scores)
              },
              team1Player1Name: currentMatch.pair1List?.first?.playerName ?? "",
              team1Player1Avatar: currentMatch.pair1List?.first?.avatar ?? "",
              team1Player2Name: currentMatch.pair1List?.dropFirst().first?.playerName ?? "",
              team1Player2Avatar: currentMatch.pair1List?.dropFirst().first?.avatar ?? "",
              team2Player1Name: currentMatch.pair2List?.first?.playerName ?? "",
              team2Player1Avatar: currentMatch.pair2List?.first?.avatar ?? "",
              team2Player2Name: currentMatch.pair2List?.dropFirst().first?.playerName ?? "",
              team2Player2Avatar: currentMatch.pair2List?.dropFirst().first?.avatar ?? ""
          )
      }
    }
      .messageNotificationPopup(
          isPresented: $isShowMessagePopup,
          matchNo: currentMatchNo,
          reason: messageReason,
          content: messageContent,
          onConfirm: {
              print("Notification confirmed")
          }
      )
      .enableInjection()
      .onAppear {
          viewModel.competitionNo = scoreStore.currentEvent?.competitionNo ?? ""
          viewModel.refresh(selectedTab: selectedTab)
      }
      .onChange(of: selectedTab) { newValue in
          viewModel.refresh(selectedTab: newValue)
      }
  }

  private func submitScores(_ scores: [String]) {
      let sets = scoreStore.scoreDetail?.scoreDetailList ?? []
      var finalScores: [(detailId: Int64, p1Score: Int32, p2Score: Int32)] = []
      for (index, set) in sets.enumerated() {
          if index * 2 + 1 < scores.count {
              finalScores.append((
                  detailId: set.detailId,
                  p1Score: Int32(scores[index * 2]) ?? 0,
                  p2Score: Int32(scores[index * 2 + 1]) ?? 0
              ))
          }
      }
      let filtered = finalScores.filter { $0.p1Score + $0.p2Score > 0 }
      if !filtered.isEmpty {
          scoreStore.submitFinalResult(scores: filtered)
      }
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif

  // MARK: - Navigation Bar
  private var navigationBar: some View {
      ZStack(content: {
          HStack(spacing: 0.adapter) {
              LeadingBtn{
                  dismiss()
              }

             

            Spacer()
          }.padding(.trailing, 16.adapter)
          
          Text(scoreStore.currentEvent?.competitionName ?? "")
          .font(.system(size: 10.adapter, weight: .medium))
          .foregroundColor(Color(hex: "#FF222429"))
      })
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
            count: tab == .ongoing ? viewModel.ongoingCount : viewModel.finishedCount,
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
  let count: Int64
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
    RootView(rootDestination: .gamedetailHome)
}
