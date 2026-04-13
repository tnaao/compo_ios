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
  let matchTitle = "小学E组男子单打"
  let matchType = "男子单打"
  let heightOffset: CGFloat

  @State private var player1 = PlayerScoreInfo(
    name: "郑泽言",
    team: "原创体育",
    score: 19,
    avatarName: "avatar1",
    isChecked: true
  )

  @State private var player2 = PlayerScoreInfo(
    name: "余苇航",
    team: "萧山羽飞",
    score: 20,
    avatarName: "avatar2",
    isChecked: true
  )

  @State private var timerString = "00:09:18"
  @State private var currentSet = 1

  init(heightOffset: CGFloat = 0) {
    self.heightOffset = heightOffset
  }

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        // Navigation Bar
        navigationBar.padding(.top,safeAreaInsets.top)

        // Score Board
          scoreBoard
              .padding(.top, 20.adapter)
              .padding(.bottom,10.adapter)

        ZStack(alignment: .bottom) {
          // Court Area
          HStack(alignment: .bottom, spacing: 0) {
              VStack {
                  MyScoreMinusBtn {

                  }
                  Spacer()
                  MyScorePlusBtn {

                  }
              }.padding(.top,0.adapter)
            courtArea
              .padding(.horizontal, 1.adapter)
              .padding(.top, 0.adapter)
              VStack {
                  MyScoreMinusBtn {

                  }
                  Spacer()
                  MyScorePlusBtn {

                  }
              }.padding(.top,0.adapter)
          }

          // Timer
          timerView
        }.padding(.horizontal, 30.adapter)
          .padding(.bottom, 40.adapter)
      }
    }
    .loginBg()
    .ignoresSafeArea(.all, edges: .bottom)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif

  // MARK: - Navigation Bar
  private var navigationBar: some View {
    HStack(spacing: 0) {
      LeadingBtn()

      Text(matchTitle)
        .font(.system(size: 16.adapter, weight: .medium))
        .foregroundColor(Color(hex: "#FF222429"))

      Spacer()
      // Action buttons
      HStack(spacing: 12.adapter) {
        // Badminton button
        MyActionBtn(icon: "ball_01") {

        }

        // Pause button
          MyActionBtn(icon: "action_pause") {

          }

        // Undo button
          MyActionBtn(icon: "action_cancel") {

          }

        // QR code button
          MyActionBtn(icon: "action_change") {

          }
      }
    }
    .padding(.trailing, 16.adapter)
  }

  // MARK: - Score Board
  private var scoreBoard: some View {
    VStack(spacing: 0) {
      // Match type badge
      Text(matchType)
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
        // Team 1
        Text(player1.team)
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
        // Team 2
        Text(player2.team)
              .font(.system(size: 16.adapter, weight: .medium))
              .foregroundColor(Color(hex: "#FF222429")).frame(maxWidth: .infinity)
      }
      .bgWhiteGray()
      .padding(.horizontal, 45.adapter)

      // Scores
        HStack(alignment:.top, spacing: 0.adapter) {
        // Score 1
        Text("\(player1.score)")
              .font(.system(size: 50.adapter, weight: .bold))
          .foregroundColor(Color(hex: "#FF222429"))
          .padding(.horizontal,12.adapter)
          .dashedBorder()
        // Score 1
        Text("\(3)")
              .font(.system(size: 30.adapter, weight: .bold))
          .foregroundColor(Color(hex: "#FF222429"))
          .padding(.horizontal,12.adapter)
          .dashedBorder()
            Spacer().fixedSize().frame(width:12.adapter)
        // Score 1
        Text("\(1)")
              .font(.system(size: 30.adapter, weight: .bold))
          .foregroundColor(Color(hex: "#FF222429"))
          .padding(.horizontal,12.adapter)
          .dashedBorder()

        // Score 2
        Text("\(player2.score)")
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
      Button(action: {}) {
          ZStack(alignment: .center) {
              VStack(spacing: 0) {
                Text("结束")
                      .font(.system(size: 13.adapter, weight: .bold))
                  .foregroundColor(Color(hex: "#FFFF6B00"))

                Text("第一局")
                      .font(.system(size: 10.adapter))
                  .foregroundColor(Color(hex: "#FFFF6B00"))
              }.offset(y:-5.adapter)
        }
        .padding(.horizontal, 20.adapter)
        .background(
            MyAssetImage(name:  "brCircleBg"
                         ,width: 100.adapter,height: 100.adapter,contentMode: .fit,bgColor: Color.clear)
        )
      }

      // Player 1 (bottom left)
      playerCard(player: player1, position: .topLeft)

      // Player 2 (top right)
      playerCard(player: player2, position: .bottomRight)
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
  private func playerCard(player: PlayerScoreInfo, position: PlayerPosition) -> some View {
      var isTop: Bool = false
      if(position == .topLeft || position == .topRight){
          isTop = true
      }
      
      var isLeft: Bool = false
      if(position == .bottomLeft || position == .topLeft){
          isLeft = true
      }
      
      var offsetX: CGFloat = isLeft ? -104 : 104
      var offsetY: CGFloat = isTop ? -48 : 48
       
      
      let ox = isLeft ? 36.adapter : -36.adapter
      return ZStack(content: {
          MyAssetImage(name: "ball_01",width: 18.adapter,height: 18.adapter).offset(
            x: ox,
          )
          PlayerCourtInfoView()
      })
      .offset(x: offsetX.adapter, y: offsetY.adapter)
  }

  // MARK: - Timer View
  private var timerView: some View {
      HStack(spacing: 0) {
      // Hours
      timerDigit(timerString.components(separatedBy: ":")[0])

      // Colon
      timerColon()

      // Minutes
      timerDigit(timerString.components(separatedBy: ":")[1])
      // Colon
      timerColon()

      // Seconds
      timerDigit(timerString.components(separatedBy: ":")[2])
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
