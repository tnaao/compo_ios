//
//  MatchScoringView.swift
//  CompoApp
//
//  Created by Qoder on 3/17/26.
//

import AdapterSwift
import SwiftUI

struct PlayerScoreInfo {
  let name: String
  let team: String
  let score: Int
  let avatarName: String
  let isChecked: Bool
}

struct MatchScoringView: View {
  @Environment(\.dismiss) private var dismiss
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @StateObject private var scoreStore:MatchScoringStore = MatchScoringStore.shared

  let heightOffset: CGFloat

  init(heightOffset: CGFloat = 0) {
    self.heightOffset = heightOffset
  }
  
  var team1Name: String {
      guard let p1List = scoreStore.currentMatch?.pair1List, !p1List.isEmpty else { return "队伍1" }
      return p1List.map { $0.playerName }.joined(separator: "/")
  }

  var team2Name: String {
      guard let p2List = scoreStore.currentMatch?.pair2List, !p2List.isEmpty else { return "队伍2" }
      return p2List.map { $0.playerName }.joined(separator: "/")
  }

  var team1CurrentScore: Int {
      guard let detail = scoreStore.scoreDetail, let last = detail.getSetScore(by: scoreStore.currentSetNumber) else { return 0 }
      return Int(last.player1Score ?? 0)
  }

  var team2CurrentScore: Int {
      guard let detail = scoreStore.scoreDetail, let last = detail.getSetScore(by: scoreStore.currentSetNumber) else { return 0 }
      return Int(last.player2Score ?? 0)
  }

  var team1SetScore: Int {
      Int(scoreStore.scoreDetail?.pair1Score ?? scoreStore.currentMatch?.pair1Score ?? 0)
  }

  var team2SetScore: Int {
      Int(scoreStore.scoreDetail?.pair2Score ?? scoreStore.currentMatch?.pair2Score ?? 0)
  }

  var currentDetailNo: String? {
      scoreStore.scoreDetail?.getSetScore(by: scoreStore.currentSetNumber)?.detailNo
  }
  
  var currentMatchNo: String? {
      scoreStore.currentMatch?.matchNo
  }

  var isSwapped: Bool {
      scoreStore.courtSwapped == 1
  }

  var leftTeamName: String {
      isSwapped ? team2Name : team1Name
  }

  var rightTeamName: String {
      isSwapped ? team1Name : team2Name
  }

  var leftTeamCurrentScore: Int {
      isSwapped ? team2CurrentScore : team1CurrentScore
  }

  var rightTeamCurrentScore: Int {
      isSwapped ? team1CurrentScore : team2CurrentScore
  }

  var leftTeamSetScore: Int {
      isSwapped ? team2SetScore : team1SetScore
  }

  var rightTeamSetScore: Int {
      isSwapped ? team1SetScore : team2SetScore
  }

  var team1ClubName: String {
      scoreStore.currentMatch?.pair1List?.first?.clubName ?? "队伍1"
  }
  
  var team2ClubName: String {
      scoreStore.currentMatch?.pair2List?.first?.clubName ?? "队伍2"
  }

  var courtNameText: String {
      scoreStore.currentMatch?.courtInfo?.courtName ?? "未分配"
  }
  
  var matchNumberText: String {
      if let order = scoreStore.currentMatch?.matchSession?.sessionOrder {
          return "第\(order)场"
      }
      return "第--场"
  }


  var body: some View {
    ZStack {
      mainContent
    }
    .overlay(warmupOverlay)
    .overlay(resultOverlay)
    .overlay(confirmBeginOverlay)
    .overlay(confirmEndOverlay)
    .overlay(earlyEndOverlay)
    .courtMessageDetailPopup(isPresented: $scoreStore.showMessageDetailPopup, message: scoreStore.unreadMessage) {
        if scoreStore.unreadCount > 1 {
            scoreStore.fetchUnreadMessages()
        }
    }
    .loginBg()
    .ignoresSafeArea(.all, edges: .bottom)
    .onAppear {
        scoreStore.startMessagePolling()
        if let match = scoreStore.currentMatch, let matchNo = match.matchNo {
            scoreStore.fetchMatchScoreDetail(matchNo: matchNo)
            // 如果比赛未开始 (matchStatus == 0)，再查询热身状态
            if match.matchStatus == 0 {
                scoreStore.checkWarmupStatus(matchNo: matchNo)
            }
        }
    }
    .onDisappear {
        scoreStore.stopMessagePolling()
    }
    .onChange(of: scoreStore.currentMatch) { match in
        if let match = match, let matchNo = match.matchNo {
            scoreStore.fetchMatchScoreDetail(matchNo: matchNo)
            if match.matchStatus == 0 {
                scoreStore.checkWarmupStatus(matchNo: matchNo)
            }
        }
    }
  }

  private var mainContent: some View {
    VStack(spacing: 0) {
      // Navigation Bar
      navigationBar.padding(.top, safeAreaInsets.top)

      // Score Board
      scoreBoard
        .padding(.top, 20.adapter)
        .padding(.bottom, 10.adapter)

      ZStack(alignment: .bottom) {
        // Court Area
        HStack(alignment: .bottom, spacing: 0) {
          VStack {
            MyScoreMinusBtn {
              scoreStore.scoreMinusLeft()
            }
            Spacer()
            MyScorePlusBtn {
              scoreStore.scorePlusLeft()
            }
          }.padding(.top, 0.adapter)
          
          courtArea
            .padding(.horizontal, 1.adapter)
            .padding(.top, 0.adapter)
          
          VStack {
            MyScoreMinusBtn {
              scoreStore.scoreMinusRight()
            }
            Spacer()
            MyScorePlusBtn {
              scoreStore.scorePlusRight()
            }
          }.padding(.top, 0.adapter)
        }

        // Timer
        timerView
      }
      .padding(.horizontal, 30.adapter)
      .padding(.bottom, 40.adapter)
    }
  }

  private var warmupOverlay: some View {
    Group {
      if scoreStore.showWarmupPopup {
        WarmupTimerPopupView(
          contentView: EmptyView(),
          onConfirm: { minutes in
            scoreStore.showWarmupPopup = false
            if let matchNo = scoreStore.currentMatch?.matchNo {
              scoreStore.updateWarmupTime(matchNo: matchNo, duration: minutes)
            } else {
              scoreStore.startWarmupCountdown(minutes: minutes)
            }
          },
          onSkip: {
            scoreStore.isWarmedUp = true
            scoreStore.showWarmupPopup = false
          },
          courtName: courtNameText,
          matchNumber: matchNumberText,
          team1ClubName: team1ClubName,
          team1SetPoints: team1SetScore,
          team1PlayerNames: team1Name,
          team1Points: team1CurrentScore,
          team2ClubName: team2ClubName,
          team2SetPoints: team2SetScore,
          team2PlayerNames: team2Name,
          team2Points: team2CurrentScore
        )
        .zIndex(2)
      }
    }
  }

  private var resultOverlay: some View {
    Group {
      if scoreStore.showMatchResult {
        matchResultPopup
          .zIndex(3)
      }
    }
  }

  private var confirmBeginOverlay: some View {
    Group {
      if scoreStore.showConfirmBegin {
        ConfirmBeginMatchPopUpView(
          setNumber: scoreStore.currentSetNumber,
          onConfirm: {
            scoreStore.confirmStartMatch()
          },
          onSkip: {
            scoreStore.cancelStartMatch()
          },
          courtName: courtNameText,
          matchNumber: matchNumberText,
          team1ClubName: team1ClubName,
          team1SetPoints: team1SetScore,
          team1PlayerNames: team1Name,
          team1Points: team1CurrentScore,
          team2ClubName: team2ClubName,
          team2SetPoints: team2SetScore,
          team2PlayerNames: team2Name,
          team2Points: team2CurrentScore
        )
        .zIndex(4)
      }
    }
  }

  private var confirmEndOverlay: some View {
    Group {
      if scoreStore.showConfirmEnd {
        ConfirmEndMatchPopUpView(
          onConfirm: {
            scoreStore.confirmEndMatch()
          },
          onSkip: {
            scoreStore.cancelEndMatch()
          },
          courtName: courtNameText,
          matchNumber: matchNumberText,
          team1ClubName: team1ClubName,
          team1SetPoints: team1SetScore,
          team1PlayerNames: team1Name,
          team1Points: team1CurrentScore,
          team2ClubName: team2ClubName,
          team2SetPoints: team2SetScore,
          team2PlayerNames: team2Name,
          team2Points: team2CurrentScore
        )
        .zIndex(4)
      }
    }
  }

  private var earlyEndOverlay: some View {
    Group {
      if scoreStore.showEarlyEndConfirm {
        EarlyEndMatchPopUpView(
          winnerName: scoreStore.earlyEndWinnerName,
          onConfirm: {
            scoreStore.confirmEarlyEnd()
          },
          onSkip: {
            scoreStore.cancelEarlyEnd()
          },
          courtName: courtNameText,
          matchNumber: matchNumberText,
          team1ClubName: team1ClubName,
          team1SetPoints: team1SetScore,
          team1PlayerNames: team1Name,
          team1Points: team1CurrentScore,
          team2ClubName: team2ClubName,
          team2SetPoints: team2SetScore,
          team2PlayerNames: team2Name,
          team2Points: team2CurrentScore
        )
        .zIndex(5)
      }
    }
  }

  // MARK: - Match Result Popup
  private var matchResultPopup: some View {
      let p1List = scoreStore.currentMatch?.pair1List ?? []
      let p2List = scoreStore.currentMatch?.pair2List ?? []
      
      let t1p1Name = p1List.count > 0 ? p1List[0].playerName : ""
      let t1p1Avatar = p1List.count > 0 ? (p1List[0].avatar ?? "") : ""
      let t1p2Name = p1List.count > 1 ? p1List[1].playerName : ""
      let t1p2Avatar = p1List.count > 1 ? (p1List[1].avatar ?? "") : ""
      
      let t2p1Name = p2List.count > 0 ? p2List[0].playerName : ""
      let t2p1Avatar = p2List.count > 0 ? (p2List[0].avatar ?? "") : ""
      let t2p2Name = p2List.count > 1 ? p2List[1].playerName : ""
      let t2p2Avatar = p2List.count > 1 ? (p2List[1].avatar ?? "") : ""
      
      return MatchResultPopupWrapper(
          scoreStore: scoreStore,
          t1p1Name: t1p1Name, t1p1Avatar: t1p1Avatar,
          t1p2Name: t1p2Name, t1p2Avatar: t1p2Avatar,
          t2p1Name: t2p1Name, t2p1Avatar: t2p1Avatar,
          t2p2Name: t2p2Name, t2p2Avatar: t2p2Avatar
      )
  }

  // MARK: - Navigation Bar
  private var navigationBar: some View {
    HStack(spacing: 0) {
      LeadingBtn()

        Text(scoreStore.currentMatch?.eventName ?? "")
        .font(.system(size: 10.adapter, weight: .medium))
        .foregroundColor(Color(hex: "#FF222429"))

      Spacer()
      // Action buttons
      HStack(spacing: 12.adapter) {
        // Badminton button
        MyActionBtn(icon: "ball_01") {
            scoreStore.actionPlay()
        }

        // Pause button
          MyActionBtn(icon: "action_pause") {
              scoreStore.actionPause()
          }

        // Undo button
          MyActionBtn(icon: "action_cancel") {
              scoreStore.actionEnd()
          }

        // QR code button
          MyActionBtn(icon: "action_change") {
              scoreStore.actionChangeSwitch()
          }
      }
    }
    .padding(.trailing, 16.adapter)
  }

  // MARK: - Score Board
  private var scoreBoard: some View {
    VStack(spacing: 0) {
      // Match type badge
        Text(scoreStore.currentMatch?.matchType ?? "")
            .font(.system(size: 10.adapter, weight: .medium))
        .foregroundColor(.white)
        .padding(.horizontal, 24.adapter)
        .padding(.vertical, 6.adapter)
        .background(
          RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: "#FF6E5DFF"))
        )
        .zIndex(1)

      HStack(spacing: 0) {
        // Team Left
        Text(leftTeamName)
              .font(.system(size: 16.adapter, weight: .medium))
              .foregroundColor(Color(hex: "#FF222429")).frame(maxWidth: .infinity)
        // VS
        Text("VS")
          .font(.system(size: 14, weight: .bold))
          .foregroundColor(.white)
          .padding(.horizontal, 12.adapter)
          .padding(.vertical, 4.adapter)
          .background(Color(hex: "#FF6E5DFF"))
          .cornerRadius(4.adapter)
        // Team Right
        Text(rightTeamName)
              .font(.system(size: 16.adapter, weight: .medium))
              .foregroundColor(Color(hex: "#FF222429")).frame(maxWidth: .infinity)
      }
      .bgWhiteGray()
      .padding(.horizontal, 45.adapter)

      // Scores
        HStack(alignment:.top, spacing: 0.adapter) {
        // Left Score Big
        Text("\(leftTeamCurrentScore)")
              .font(.system(size: 50.adapter, weight: .bold))
          .foregroundColor(Color(hex: "#FF222429"))
          .padding(.horizontal,12.adapter)
          .dashedBorder()
        // Left Set Score
        Text("\(leftTeamSetScore)")
              .font(.system(size: 30.adapter, weight: .bold))
          .foregroundColor(Color(hex: "#FF222429"))
          .padding(.horizontal,12.adapter)
          .dashedBorder()
            Spacer().fixedSize().frame(width:12.adapter)
        // Right Set Score
        Text("\(rightTeamSetScore)")
              .font(.system(size: 30.adapter, weight: .bold))
          .foregroundColor(Color(hex: "#FF222429"))
          .padding(.horizontal,12.adapter)
          .dashedBorder()

        // Right Score Big
        Text("\(rightTeamCurrentScore)")
              .font(.system(size: 50.adapter, weight: .bold))
          .foregroundColor(Color.red)
          .padding(.horizontal,12.adapter)
          .dashedBorder()
        }
    }
  }

  // MARK: - Court Area
  private var courtArea: some View {
    ZStack {
      // Court background
      RoundedRectangle(cornerRadius: 0.adapter)
        .fill(Color(hex: "#FF6E5DFF").opacity(0.8))

      // Court lines
        Image("courtBg").resizable()
            .clipped()

      // Center end game button
      Button(action: {
          if scoreStore.runningState == .playing {
              scoreStore.actionEnd()
          }
          
          if scoreStore.runningState == .notStarted {
              scoreStore.actionPlay()
          }
      }) {
          ZStack(alignment: .center) {
              VStack(spacing: 0) {
                  Text(scoreStore.runningState.rawValue)
                      .font(.system(size: 13.adapter, weight: .bold))
                  .foregroundColor(Color(hex: "#FFFF6B00"))

                  Text(scoreStore.gameStateText)
                      .font(.system(size: 10.adapter))
                  .foregroundColor(Color(hex: "#FFFF6B00"))
                  .xVisible(scoreStore.gameStateText.isNotBlank)
              }.offset(y:-5.adapter)
        }
        .padding(.horizontal, 20.adapter)
        .background(
            MyAssetImage(name:  "brCircleBg"
                         ,width: 100.adapter,height: 100.adapter,contentMode: .fit,bgColor: Color.clear)
        )
      }

      // Compute left/right lists
      let leftList = isSwapped ? scoreStore.currentMatch?.pair2List : scoreStore.currentMatch?.pair1List
      let rightList = isSwapped ? scoreStore.currentMatch?.pair1List : scoreStore.currentMatch?.pair2List
      let leftTeamId: Int32 = isSwapped ? 2 : 1
      let rightTeamId: Int32 = isSwapped ? 1 : 2

      // Left Court
      if let p1 = leftList?.first {
          playerCard(name: p1.playerName, avatar: p1.avatar ?? "", playerId: p1.playerId, position: .topLeft, team: leftTeamId)
      }
      if let list = leftList, list.count > 1 {
          let p2 = list[1]
          playerCard(name: p2.playerName, avatar: p2.avatar ?? "", playerId: p2.playerId, position: .bottomLeft, team: leftTeamId)
      }

      // Right Court
      if let p3 = rightList?.first {
          playerCard(name: p3.playerName, avatar: p3.avatar ?? "", playerId: p3.playerId, position: .bottomRight, team: rightTeamId)
      }
      if let list = rightList, list.count > 1 {
          let p4 = list[1]
          playerCard(name: p4.playerName, avatar: p4.avatar ?? "", playerId: p4.playerId, position: .topRight, team: rightTeamId)
      }
    }
  }

  // MARK: - Court Lines
  private var courtLines: some View {
    GeometryReader { geometry in
      let width = geometry.size.width
      let height = geometry.size.height

      ZStack {
        // Center line vertical
        Rectangle()
          .fill(Color.white.opacity(0.5))
          .frame(width: 1, height: height)

        // Center line horizontal
        Rectangle()
          .fill(Color.white.opacity(0.5))
          .frame(width: width, height: 1)

        // Service lines
        Rectangle()
          .fill(Color.white.opacity(0.3))
          .frame(width: width * 0.6, height: 1)
          .offset(y: -height * 0.25)

        Rectangle()
          .fill(Color.white.opacity(0.3))
          .frame(width: width * 0.6, height: 1)
          .offset(y: height * 0.25)

        // Side lines
        Rectangle()
          .fill(Color.white.opacity(0.3))
          .frame(width: 1, height: height * 0.5)
          .offset(x: -width * 0.3)

        Rectangle()
          .fill(Color.white.opacity(0.3))
          .frame(width: 1, height: height * 0.5)
          .offset(x: width * 0.3)
      }
    }
  }

  // MARK: - Player Card
  private func playerCard(name: String, avatar: String, playerId: Int64, position: PlayerPosition, team: Int32) -> some View {
      var isTop: Bool = false
      if(position == .topLeft || position == .topRight){
          isTop = true
      }
      
      var isLeft: Bool = false
      if(position == .bottomLeft || position == .topLeft){
          isLeft = true
      }
      
      let offsetX: CGFloat = isLeft ? -104 : 104
      let offsetY: CGFloat = isTop ? -48 : 48
       
      
      let ox = isLeft ? 36.adapter : -36.adapter
      
      let statusValue = (team == 1) ? (scoreStore.scoreDetail?.pair1CheckinStatus ?? 0) : (scoreStore.scoreDetail?.pair2CheckinStatus ?? 0)
      let status = CheckInStatus(rawValue: Int(statusValue)) ?? .unchecked
      let isDefaultServer = scoreStore.firstServerId == nil && playerId == scoreStore.currentMatch?.pair1List?.first?.playerId
      
      return ZStack(content: {
          MyAssetImage(name: "ball_01",width: 18.adapter,height: 18.adapter).offset(
            x: ox,
          )
          .opacity((scoreStore.firstServerId == playerId || isDefaultServer) ? 1 : 0)
          
          PlayerCourtInfoView(name: name, iconUrl: avatar, checkInStatus: status)
      })
      .offset(x: offsetX.adapter, y: offsetY.adapter)
      .onTapGesture {
          scoreStore.actionStartServe(playerId: playerId, team: team)
      }
  }

  // MARK: - Timer View
  private var timerView: some View {
      HStack(spacing: 0) {
      // Hours
      timerDigit(scoreStore.timerString.components(separatedBy: ":")[0])

      // Colon
      timerColon()

      // Minutes
      timerDigit(scoreStore.timerString.components(separatedBy: ":")[1])
      // Colon
      timerColon()

      // Seconds
      timerDigit(scoreStore.timerString.components(separatedBy: ":")[2])
    }
    .cornerRadius(4.adapter)
  }

  private func timerDigit(_ digit: String) -> some View {
    Text(digit)
      .font(.system(size: 18.adapter, weight: .bold))
      .foregroundColor(Color(hex: "#FF2C3E50"))
      .padding(.horizontal,4.adapter)
      .frame(height: 30.adapter)
      .background(Color(hex: "#FF88D90F"))
  }

  private func timerColon() -> some View {
    Text(":")
      .font(.system(size: 28.adapter, weight: .bold))
      .foregroundColor(Color(hex: "#FF88D90F"))
      .padding(.horizontal,6.adapter)
  }
}

enum PlayerPosition {
  case topLeft
  case topRight
  case bottomLeft
  case bottomRight
}

#Preview {
  MatchScoringView(heightOffset: 0)
}
