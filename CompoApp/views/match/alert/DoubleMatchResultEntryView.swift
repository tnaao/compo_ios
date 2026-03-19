import AdapterSwift
import SwiftUI

// MARK: - Double Match Result Entry Popup
struct DoubleMatchResultEntryView: View {
  // Callbacks
  var onCancel: (() -> Void)?
  var onConfirm: (() -> Void)?

  // Team 1 data (2 players)
  let team1Player1Name: String
  let team1Player1Avatar: String
  let team1Player2Name: String
  let team1Player2Avatar: String

  // Team 2 data (2 players)
  let team2Player1Name: String
  let team2Player1Avatar: String
  let team2Player2Name: String
  let team2Player2Avatar: String

  // Scores (3 sets)
  @State var set1Score1: String = ""
  @State var set1Score2: String = ""
  @State var set2Score1: String = ""
  @State var set2Score2: String = ""
  @State var set3Score1: String = ""
  @State var set3Score2: String = ""

  var body: some View {
    ZStack {
      // Dark Overlay
      Color.black.opacity(0.4)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture { onCancel?() }

      // Modal Container
      VStack(spacing: 0) {

        // Top Section - Title & Players (Gradient Background)
        VStack(spacing: 0) {
          // Title
          Text("录入结果")
            .font(.system(size: 20.adapter, weight: .bold))
            .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
            .padding(.top, 20.adapter)

          Spacer().frame(height: 24.adapter)

          // Players Row - Team 1 (2 players) vs Team 2 (2 players)
          HStack(spacing: 24.adapter) {
            // Team 1 - Two players
            HStack(spacing: 8.adapter) {
              // Player 1
              VStack(spacing: 8.adapter) {
                ZStack {
                  Circle()
                    .fill(Color.white)
                    .frame(width: 35.adapter, height: 35.adapter)
                    .shadow(color: Color.black.opacity(0.1), radius: 4.adapter, x: 0, y: 2.adapter)

                  MyNetImage(width: 27.adapter, height: 27.adapter)
                    .clipShape(Circle())
                }

                Text(team1Player1Name)
                  .font(.system(size: 12.adapter))
                  .foregroundColor(Color(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
              }

              // Player 2
              VStack(spacing: 8.adapter) {
                ZStack {
                  Circle()
                    .fill(Color.white)
                    .frame(width: 35.adapter, height: 35.adapter)
                    .shadow(color: Color.black.opacity(0.1), radius: 4.adapter, x: 0, y: 2.adapter)

                  MyNetImage(width: 27.adapter, height: 27.adapter)
                    .clipShape(Circle())
                }

                Text(team1Player2Name)
                  .font(.system(size: 12.adapter))
                  .foregroundColor(Color(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
              }
            }

            // VS Badge
            ZStack {
              // Rackets crossed icon
              Image(systemName: "tennis.racket")
                .font(.system(size: 28.adapter))
                .foregroundColor(Color(red: 255 / 255, green: 100 / 255, blue: 100 / 255))
                .rotationEffect(.degrees(-30))
                .offset(x: -6.adapter, y: -2.adapter)

              Image(systemName: "tennis.racket")
                .font(.system(size: 28.adapter))
                .foregroundColor(Color(red: 100 / 255, green: 150 / 255, blue: 255 / 255))
                .rotationEffect(.degrees(30))
                .offset(x: 6.adapter, y: 2.adapter)

              // VS text
              Text("VS")
                .font(.system(size: 12.adapter, weight: .bold))
                .foregroundColor(Color(red: 255 / 255, green: 140 / 255, blue: 0 / 255))
                .offset(y: -12.adapter)
            }
            .frame(width: 50.adapter, height: 50.adapter)

            // Team 2 - Two players
            HStack(spacing: 8.adapter) {
              // Player 1
              VStack(spacing: 8.adapter) {
                ZStack {
                  Circle()
                    .fill(Color.white)
                    .frame(width: 35.adapter, height: 35.adapter)
                    .shadow(color: Color.black.opacity(0.1), radius: 4.adapter, x: 0, y: 2.adapter)

                  MyNetImage(width: 27.adapter, height: 27.adapter)
                    .clipShape(Circle())
                }

                Text(team2Player1Name)
                  .font(.system(size: 12.adapter))
                  .foregroundColor(Color(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
              }

              // Player 2
              VStack(spacing: 8.adapter) {
                ZStack {
                  Circle()
                    .fill(Color.white)
                    .frame(width: 35.adapter, height: 35.adapter)
                    .shadow(color: Color.black.opacity(0.1), radius: 4.adapter, x: 0, y: 2.adapter)

                  MyNetImage(width: 27.adapter, height: 27.adapter)
                    .clipShape(Circle())
                }

                Text(team2Player2Name)
                  .font(.system(size: 12.adapter))
                  .foregroundColor(Color(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
              }
            }
          }
          .padding(.horizontal, 32.adapter)
          .padding(.bottom, 15.adapter)
        }
        .frame(maxWidth: .infinity)
        .background(
          LinearGradient(
            colors: [
              Color(red: 235 / 255, green: 245 / 255, blue: 255 / 255),
              Color(red: 245 / 255, green: 235 / 255, blue: 255 / 255),
              Color(red: 255 / 255, green: 240 / 255, blue: 240 / 255),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )

        // Bottom White Section - Score Input
        VStack(spacing: 16.adapter) {
          Spacer().frame(height: 8.adapter)

          // Set 1
          ScoreInputRow(
            label: "第一局比分",
            score1: $set1Score1,
            score2: $set1Score2,
            placeholder1: "7",
            placeholder2: "15"
          )

          // Set 2
          ScoreInputRow(
            label: "第二局比分",
            score1: $set2Score1,
            score2: $set2Score2,
            placeholder1: "比分",
            placeholder2: "比分"
          )

          // Set 3
          ScoreInputRow(
            label: "第三局比分",
            score1: $set3Score1,
            score2: $set3Score2,
            placeholder1: "比分",
            placeholder2: "比分"
          )

          Spacer().frame(height: 0.adapter)

          // Bottom Buttons
          HStack(spacing: 0) {
            Button(action: { onCancel?() }) {
              Text("取消")
                .font(.system(size: 14.adapter, weight: .medium))
                .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Button(action: { onConfirm?() }) {
              Text("同意")
                .font(.system(size: 14.adapter, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
          }
          .frame(width: 180.adapter, height: 36.adapter)
          .background(content: {
            HStack {
              Spacer().bgImage("alert_btn_bg_s1").offset(x: 4.adapter)
              Spacer().bgImage("alert_btn_bg_s2").offset(x: -4.adapter)
            }
          })
          .clipShape(Capsule())
          .padding(.bottom, 20.adapter)
        }
        .background(Color.white)
      }
      .frame(width: 417.adapter)
      .background(Color.white)
      .cornerRadius(14.adapter)
      .shadow(color: Color.black.opacity(0.15), radius: 14.adapter, x: 0, y: 6.adapter)
    }
    .transition(.opacity.combined(with: .scale(scale: 0.95)))
  }
}

// MARK: - Score Input Row
private struct ScoreInputRow: View {
  let label: String
  @Binding var score1: String
  @Binding var score2: String
  let placeholder1: String
  let placeholder2: String

  var body: some View {
    HStack(spacing: 20.adapter) {
      // Left Score Input
      ScoreTextField(text: $score1, placeholder: placeholder1)

      // Label
      Text(label)
        .font(.system(size: 14.adapter))
        .foregroundColor(Color(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
        .frame(width: 80.adapter)

      // Right Score Input
      ScoreTextField(text: $score2, placeholder: placeholder2)
    }
    .padding(.horizontal, 40.adapter)
  }
}

// MARK: - Score Text Field
private struct ScoreTextField: View {
  @Binding var text: String
  let placeholder: String

  var body: some View {
    TextField("", text: $text)
      .font(.system(size: 16.adapter, weight: .medium))
      .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
      .multilineTextAlignment(.center)
      .frame(width: 80.adapter, height: 40.adapter)
      .background(Color.white)
      .overlay(
        RoundedRectangle(cornerRadius: 4.adapter)
          .stroke(Color(red: 200 / 255, green: 200 / 255, blue: 210 / 255), lineWidth: 1.adapter)
      )
      .overlay(
        Group {
          if text.isEmpty {
            Text(placeholder)
              .font(.system(size: 16.adapter))
              .foregroundColor(Color(red: 150 / 255, green: 150 / 255, blue: 160 / 255))
          }
        }
      )
  }
}

// MARK: - Preview
#Preview {
  DoubleMatchResultEntryView(
    onCancel: {},
    onConfirm: {},
    team1Player1Name: "余苇航",
    team1Player1Avatar: "avatar1",
    team1Player2Name: "吴威航",
    team1Player2Avatar: "avatar2",
    team2Player1Name: "陈泽然",
    team2Player1Avatar: "avatar3",
    team2Player2Name: "郑泽言",
    team2Player2Avatar: "avatar4"
  )
  .previewInterfaceOrientation(.landscapeLeft)
}
