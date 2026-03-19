import AdapterSwift
import SwiftUI

// MARK: - Models

struct PlayerModel: Identifiable {
  let id = UUID()
  let name: String
  let hasCrown: Bool
}

struct MatchModel1: Identifiable {
  let id = UUID()
  let court: String
  let matchNumber: String
  let matchInfo: String
  let team1: [PlayerModel]
  let team2: [PlayerModel]
  let scoreTeam1: Int
  let scoreTeam2: Int
  let courtChange: (from: String, to: String)?
}

// MARK: - Sample Data for Preview

extension MatchModel1 {
  static let sample = MatchModel1(
    court: "场地8",
    matchNumber: "第13场",
    matchInfo: "小学E组男子双打 8进4 [XEMS218]",
    team1: [PlayerModel(name: "李泽凡", hasCrown: true), PlayerModel(name: "余飞", hasCrown: true)],
    team2: [PlayerModel(name: "马言", hasCrown: false), PlayerModel(name: "陈苇航", hasCrown: false)],
    scoreTeam1: 2,
    scoreTeam2: 0,
    courtChange: nil
  )

  static let sampleWithCourtChange = MatchModel1(
    court: "场地7",
    matchNumber: "第14场",
    matchInfo: "小学E组女子双打 8进4 [XEWS205]",
    team1: [PlayerModel(name: "余苇航", hasCrown: false), PlayerModel(name: "吴威航", hasCrown: false)],
    team2: [PlayerModel(name: "陈泽然", hasCrown: true), PlayerModel(name: "郑泽言", hasCrown: true)],
    scoreTeam1: 2,
    scoreTeam2: 0,
    courtChange: (from: "场地7", to: "场地8")
  )
}

// MARK: - Match Card Component

struct MatchCardView: View {
  let match: MatchModel1

  var body: some View {
    VStack(spacing: 16) {
      // Header Info
      HStack(spacing: 6) {
        Text(match.court)
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(Color(red: 235 / 255, green: 121 / 255, blue: 0 / 255))

        Text("|")
          .font(.system(size: 12))
          .foregroundColor(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255))

        Text(match.matchNumber)
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(Color(red: 80 / 255, green: 100 / 255, blue: 255 / 255))

        Text("(\(match.matchInfo))")
          .font(.system(size: 14))
          .foregroundColor(Color(red: 124 / 255, green: 124 / 255, blue: 124 / 255))

        Spacer()
      }
      .padding(.horizontal, 24)
      .padding(.top, 24)

      // Match Details Row
      HStack(alignment: .center, spacing: 0) {

        Spacer(minLength: 0)

        // Left Team Players
        HStack(spacing: 7.adapter) {
          ForEach(match.team1) { player in
            PlayerView(player: player)
          }
        }

        Spacer(minLength: 20)

        // Left Score
        Text("\(match.scoreTeam1)")
          .font(.system(size: 32, weight: .bold))
          .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))

        Spacer(minLength: 20)

        // Center VS Section
        VStack(spacing: 6) {
          VSLogoView()
            .frame(height: 40)

          if let courtChange = match.courtChange {
            HStack(spacing: 4) {
              Text(courtChange.from)
                .font(.system(size: 11))
                .foregroundColor(Color.black)

              ZStack {
                Circle()
                  .fill(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
                  .frame(width: 14, height: 14)
                Text("换")
                  .font(.system(size: 9))
                  .foregroundColor(.white)
              }

              Text(courtChange.to)
                .font(.system(size: 11))
                .foregroundColor(Color.black)
            }
          } else {
            // Keep space balanced if no court change
            Color.clear.frame(height: 14)
          }
        }
        .frame(width: 80)

        Spacer(minLength: 20)

        // Right Score
        Text("\(match.scoreTeam2)")
          .font(.system(size: 32, weight: .bold))
          .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))

        Spacer(minLength: 20)

        // Right Team Players
        HStack(spacing: 24) {
          ForEach(match.team2) { player in
            PlayerView(player: player)
          }
        }

        Spacer(minLength: 0)

        // Action Buttons Right Side
        VStack(spacing: 12) {
          Button(action: {}) {
            Text("重新签名")
              .font(.system(size: 14, weight: .medium))
              .foregroundColor(.white)
              .frame(width: 104, height: 38)
              .background(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
              .clipShape(Capsule())
          }

          Button(action: {}) {
            Text("录入结果")
              .font(.system(size: 14, weight: .medium))
              .foregroundColor(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
              .frame(width: 104, height: 38)
              .background(Color.white)
              .clipShape(Capsule())
              .overlay(
                Capsule()
                  .stroke(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255), lineWidth: 1)
              )
          }
        }
        .padding(.trailing, 24)
      }
      .padding(.bottom, 24)
    }
    .background(Color.white)
    .cornerRadius(12)
  }
}

// MARK: - Helper Subviews

struct PlayerView: View {
  let player: PlayerModel

  var body: some View {
    VStack(spacing: 8) {
      ZStack(alignment: .topLeading) {
        // Main Avatar background + gradient stroke
        Circle()
          .fill(Color(red: 235 / 255, green: 240 / 255, blue: 250 / 255))
          .frame(width: 60, height: 60)
          .overlay(
            Image(systemName: "person.crop.circle.fill")
              .resizable()
              .foregroundColor(Color(red: 160 / 255, green: 170 / 255, blue: 190 / 255))
          )
          .overlay(
            Circle()
              .strokeBorder(
                LinearGradient(
                  colors: [
                    Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255).opacity(0.8),
                    Color(red: 200 / 255, green: 180 / 255, blue: 255 / 255).opacity(0.4),
                  ],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                ),
                lineWidth: 2
              )
          )

        // Crown Badge
        if player.hasCrown {
          Image(systemName: "crown.fill")
            .font(.system(size: 16))
            .foregroundColor(Color(red: 255 / 255, green: 200 / 255, blue: 0 / 255))
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
            .offset(x: -8, y: -6)
            .background(
              Circle()
                .fill(Color.white)
                .frame(width: 22, height: 22)
                .offset(x: -8, y: -6)
            )
        }
      }

      Text(player.name)
        .font(.system(size: 14, weight: .regular))
        .foregroundColor(Color(red: 102 / 255, green: 102 / 255, blue: 102 / 255))
    }
  }
}

// Custom Placeholder implementation for the VS icon
struct VSLogoView: View {
  var body: some View {
    ZStack {
      Image(systemName: "tennis.racket")
        .font(.system(size: 20))
        .foregroundColor(Color.pink.opacity(0.6))
        .rotationEffect(.degrees(45))
        .offset(x: -6, y: 8)

      Image(systemName: "tennis.racket")
        .font(.system(size: 20))
        .foregroundColor(Color.blue.opacity(0.6))
        .rotationEffect(.degrees(-135))
        .offset(x: 6, y: 8)

      Text("VS")
        .font(.system(size: 24, weight: .black, design: .rounded))
        .foregroundStyle(
          LinearGradient(
            colors: [
              Color.orange, Color.pink, Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .italic()
        .offset(y: -4)
    }
  }
}

// MARK: - Previews

struct MatchCardView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 120) {
      // Card without court change
      MatchCardView(match: .sample)

      // Card with court change
      MatchCardView(match: .sampleWithCourtChange)
    }
    .padding(.horizontal,12)
    .padding(.vertical,12)
    .background(Color(red: 242 / 255, green: 243 / 255, blue: 249 / 255))
    .previewInterfaceOrientation(.landscapeLeft)
  }
}
