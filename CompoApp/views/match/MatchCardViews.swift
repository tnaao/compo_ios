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

struct MatchCardMultiView: View {
  let match: MatchModel1
  
  @Environment(\.isLandscape) var isLandscape:Bool
  var body: some View {
    VStack(spacing: 0) {
      // Header Info
      HStack(spacing: 6) {
        Text(match.court)
              .font(.system(size: 10.adapter, weight: .semibold))
          .foregroundColor(Color(red: 235 / 255, green: 121 / 255, blue: 0 / 255))

        Text("|")
          .font(.system(size: 12))
          .foregroundColor(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255))

        Text(match.matchNumber)
              .font(.system(size: 10.adapter, weight: .semibold))
          .foregroundColor(Color(red: 80 / 255, green: 100 / 255, blue: 255 / 255))

        Text("(\(match.matchInfo))")
              .font(.system(size: 9.adapter))
          .foregroundColor(Color(red: 124 / 255, green: 124 / 255, blue: 124 / 255))

        Spacer()
      }
      .padding(.horizontal, 24)
      .padding(.top, 16.adapter)
      // Match Details Row
      HStack(alignment: .center, spacing: 0) {

        Spacer().fixedSize().frame(width: 40.adapter)

        // Left Team Players
        HStack(spacing: 7.adapter) {
            ForEach(Array(match.team1.enumerated()), id: \.element.id) { player in
                if(player.offset == 0){
                    PlayerView(player: player.element)
                }else {
                    PlayerView(player: player.element)
                }
          }
        }.padding(.top,8.adapter)

        Spacer(minLength:!isLandscape ? 10 : 20)

        // Left Score
        Text("\(match.scoreTeam1)")
              .font(.system(size: 12.adapter, weight: .bold))
          .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
          .padding(.bottom,5.adapter)

        Spacer(minLength: 10)

        // Center VS Section
        VStack(spacing: 0) {
            VSLogoView().xDisplay(true)
                .offset(y:7.adapter)

          if let courtChange = match.courtChange {
              HStack(spacing: 2.adapter) {
              Text(courtChange.from)
                    .font(.system(size: 9.adapter))
                .foregroundColor(Color.black)

              ZStack {
                Circle()
                  .fill(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
                  .frame(width: 14.adapter, height: 14.adapter)
                Text("换")
                      .font(.system(size: 8.adapter))
                  .foregroundColor(.white)
              }
              

              Text(courtChange.to)
                    .font(.system(size: 9.adapter))
                .foregroundColor(Color.black)
            }
          } else {
            // Keep space balanced if no court change
              Color.clear.frame(height: 14.adapter)
          }
        }
        .frame(maxWidth: 80.adapter)
        .padding(.bottom,0.adapter)

        Spacer(minLength: 10)

        // Right Score
        Text("\(match.scoreTeam2)")
              .font(.system(size: 12.adapter, weight: .bold))
          .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
          .padding(.bottom,5.adapter)
        
        Spacer(minLength:!isLandscape ? 10 : 20)

        // Right Team Players
        HStack(spacing: 7.adapter) {
          ForEach(match.team2) { player in
              PlayerView(player: player)
          }
        }.padding(.top,8)

        Spacer()

        // Action Buttons Right Side
        MatchCardActionsView()
      }
      .padding(.bottom, 24)
    }
    .frame(height: 108.adapter)
    .background(Color.white)
    .cornerRadius(12.adapter)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// MARK: - Helper Subviews

struct PlayerView: View {
  let player: PlayerModel

  var body: some View {
      VStack(spacing: 7.adapter) {
      PlayerIconView(url: nil, hasWinnerBadge: player.hasCrown)

      Text(player.name)
              .font(.system(size: 9.adapter, weight: .regular))
        .foregroundColor(Color(red: 102 / 255, green: 102 / 255, blue: 102 / 255))
        .lineLimit(1)
    }
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// Custom Placeholder implementation for the VS icon
struct VSLogoView: View {
  var body: some View {
    ZStack {
      MyAssetImage(
        name: "vs",
        width: 28.adapter,
        height: 50.adapter
      )
    }
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// MARK: - Single Match Components

struct MatchModelSingle: Identifiable {
  let id = UUID()
  let court: String
  let matchNumber: String
  let matchInfo: String
  let player1: PlayerModel
  let player2: PlayerModel
  let scoreTeam1: Int
  let scoreTeam2: Int
  let courtChange: (from: String, to: String)?
}

extension MatchModelSingle {
  static let sample = MatchModelSingle(
    court: "场地8",
    matchNumber: "第13场",
    matchInfo: "小学E组男子单打 8进4 [XEMS218]",
    player1: PlayerModel(name: "余苇航【原创体育】", hasCrown: true),
    player2: PlayerModel(name: "郑泽言【萧山羽飞】", hasCrown: false),
    scoreTeam1: 21,
    scoreTeam2: 19,
    courtChange: nil
  )

  static let sampleWithCourtChange = MatchModelSingle(
    court: "场地7",
    matchNumber: "第14场",
    matchInfo: "小学E组女子单打 8进4 [XEWS205]",
    player1: PlayerModel(name: "吴苇航【原创体育】", hasCrown: false),
    player2: PlayerModel(name: "郑泽然【萧山羽飞】", hasCrown: true),
    scoreTeam1: 17,
    scoreTeam2: 21,
    courtChange: (from: "场地7", to: "场地8")
  )
}

struct MatchCardSingleView: View {
  let match: MatchModelSingle
  
  var body: some View {
    VStack(spacing: 0) {
      // Header Info
      HStack(spacing: 6) {
        Text(match.court)
              .font(.system(size: 10.adapter, weight: .semibold))
          .foregroundColor(Color(red: 235 / 255, green: 121 / 255, blue: 0 / 255))

        Text("|")
          .font(.system(size: 12))
          .foregroundColor(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255))

        Text(match.matchNumber)
          .font(.system(size: 10.adapter, weight: .semibold))
          .foregroundColor(Color(red: 80 / 255, green: 100 / 255, blue: 255 / 255))

        Text("(\(match.matchInfo))")
          .font(.system(size: 9.adapter))
          .foregroundColor(Color(red: 124 / 255, green: 124 / 255, blue: 124 / 255))

        Spacer()
      }
      .padding(.horizontal, 20.adapter)
      .padding(.top, 16.adapter)

      // Match Details Row
      HStack(alignment: .center, spacing: 0) {

        Spacer().fixedSize().frame(width: 20.adapter)

        // Left Player
        PlayerView(player: match.player1).frame(maxWidth: 80.adapter)

        Spacer(minLength: 20)

        // Left Score
        Text("\(match.scoreTeam1)")
              .font(.system(size: 12.adapter, weight: .bold)) // Restored to 12.adapter
          .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
          .padding(.bottom,24.adapter)

        Spacer(minLength: 10)

        // Center VS Section
        VStack(spacing: 0) {
          VSLogoView()

          if let courtChange = match.courtChange {
              HStack(spacing: 2.adapter) {
              Text(courtChange.from)
                    .font(.system(size: 9.adapter))
                .foregroundColor(Color.black)

              ZStack {
                Circle()
                  .fill(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
                  .frame(width: 14.adapter, height: 14.adapter)
                Text("换")
                      .font(.system(size: 8.adapter))
                  .foregroundColor(.white)
              }
              
              Text(courtChange.to)
                    .font(.system(size: 9.adapter))
                .foregroundColor(Color.black)
            }
          } else {
            // Keep space balanced if no court change
              Color.clear.frame(height: 14.adapter)
          }
        }
        .frame(maxWidth: 80.adapter)
        .padding(.bottom,0.adapter)

        Spacer(minLength: 10)

        // Right Score
        Text("\(match.scoreTeam2)")
              .font(.system(size: 12.adapter, weight: .bold)) // Restored to 12.adapter
          .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
          .padding(.bottom,24.adapter)

        Spacer(minLength: 20)

        // Right Player
          PlayerView(player: match.player2)

        Spacer()

        // Action Buttons Right Side
        MatchCardActionsView()
      }
      .padding(.bottom, 24)
    }
    .frame(height: 108.adapter)
    .background(Color.white)
    .cornerRadius(12.adapter)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

struct MatchCardSingleGoingView: View {
  let match: MatchModelSingle

  var body: some View {
    VStack(spacing: 0) {
      // Header Info
      HStack(spacing: 6) {
        Text(match.court)
              .font(.system(size: 10.adapter, weight: .semibold))
          .foregroundColor(Color(red: 235 / 255, green: 121 / 255, blue: 0 / 255))

        Text("|")
          .font(.system(size: 12))
          .foregroundColor(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255))

        Text(match.matchNumber)
          .font(.system(size: 10.adapter, weight: .semibold))
          .foregroundColor(Color(red: 80 / 255, green: 100 / 255, blue: 255 / 255))

        Text("(\(match.matchInfo))")
          .font(.system(size: 9.adapter))
          .foregroundColor(Color(red: 124 / 255, green: 124 / 255, blue: 124 / 255))

        Spacer()
      }
      .padding(.horizontal, 20.adapter)
      .padding(.top, 16.adapter)

      // Match Details Row
      HStack(alignment: .center, spacing: 0) {

        Spacer().fixedSize().frame(width: 20.adapter)

        // Left Player
        PlayerView(player: match.player1).frame(maxWidth: 80.adapter)

        Spacer()

        // Center VS Section
        VStack(spacing: 0) {
          VSLogoView()

          if let courtChange = match.courtChange {
              HStack(spacing: 2.adapter) {
              Text(courtChange.from)
                    .font(.system(size: 9.adapter))
                .foregroundColor(Color.black)

              ZStack {
                Circle()
                  .fill(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
                  .frame(width: 14.adapter, height: 14.adapter)
                Text("换")
                      .font(.system(size: 8.adapter))
                  .foregroundColor(.white)
              }
              
              Text(courtChange.to)
                    .font(.system(size: 9.adapter))
                .foregroundColor(Color.black)
            }
          } else {
            // Keep space balanced if no court change
              Color.clear.frame(height: 14.adapter)
          }
        }
        .frame(maxWidth: 80.adapter)
        .padding(.bottom,0.adapter)

        Spacer()

        // Right Player
          PlayerView(player: match.player2).frame(maxWidth: 80.adapter)

        Spacer()

        // Action Buttons Right Side
        MatchCardActionsView(isGoing: true)
      }
      .padding(.bottom, 24)
    }
    .frame(height: 108.adapter)
    .background(Color.white)
    .cornerRadius(12.adapter)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

struct MatchCardMultiGoingView: View {
  let match: MatchModel1

  var body: some View {
    VStack(spacing: 0) {
      // Header Info
      HStack(spacing: 6) {
        Text(match.court)
              .font(.system(size: 10.adapter, weight: .semibold))
          .foregroundColor(Color(red: 235 / 255, green: 121 / 255, blue: 0 / 255))

        Text("|")
          .font(.system(size: 12))
          .foregroundColor(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255))

        Text(match.matchNumber)
              .font(.system(size: 10.adapter, weight: .semibold))
          .foregroundColor(Color(red: 80 / 255, green: 100 / 255, blue: 255 / 255))

        Text("(\(match.matchInfo))")
              .font(.system(size: 9.adapter))
          .foregroundColor(Color(red: 124 / 255, green: 124 / 255, blue: 124 / 255))

        Spacer()
      }
      .padding(.horizontal, 24)
      .padding(.top, 16.adapter)
      
      // Match Details Row
      HStack(alignment: .center, spacing: 0) {

        Spacer().fixedSize().frame(width: 40.adapter)

        // Left Team Players
        HStack(spacing: 7.adapter) {
            ForEach(Array(match.team1.enumerated()), id: \.element.id) { player in
                if(player.offset == 0){
                    PlayerView(player: player.element)
                }else {
                    PlayerView(player: player.element)
                }
          }
        }.padding(.top,8.adapter)

        Spacer()

        // Center VS Section
        VStack(spacing: 0) {
            VSLogoView().xDisplay(true)
                .offset(y:7.adapter)

          if let courtChange = match.courtChange {
              HStack(spacing: 2.adapter) {
              Text(courtChange.from)
                    .font(.system(size: 9.adapter))
                .foregroundColor(Color.black)

              ZStack {
                Circle()
                  .fill(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
                  .frame(width: 14.adapter, height: 14.adapter)
                Text("换")
                      .font(.system(size: 8.adapter))
                  .foregroundColor(.white)
              }
              
              Text(courtChange.to)
                    .font(.system(size: 9.adapter))
                .foregroundColor(Color.black)
            }
          } else {
            // Keep space balanced if no court change
              Color.clear.frame(height: 14.adapter)
          }
        }
        .frame(maxWidth: 80.adapter)
        .padding(.bottom,0.adapter)

        Spacer()

        // Right Team Players
        HStack(spacing: 7.adapter) {
          ForEach(match.team2) { player in
              PlayerView(player: player)
          }
        }.padding(.top,8)

        Spacer()

        // Action Buttons Right Side
        MatchCardActionsView(isGoing: true)
      }
      .padding(.bottom, 24)
    }
    .frame(height: 108.adapter)
    .background(Color.white)
    .cornerRadius(12.adapter)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// MARK: - Previews

struct MatchCardView_Previews: PreviewProvider {
  static var previews: some View {
      ScrollView(content: {
          VStack(spacing: 20.adapter) {
          // Multi View Previews (Completed)
          MatchCardMultiView(match: .sampleWithCourtChange)
          MatchCardMultiView(match: .sample)
          
          // Multi View Previews (Going)
          MatchCardMultiGoingView(match: .sampleWithCourtChange)
          MatchCardMultiGoingView(match: .sample)
          
          // Single View Previews (Completed)
          MatchCardSingleView(match: .sample)
          MatchCardSingleView(match: .sampleWithCourtChange)
          
          // Single View Previews (Going)
          MatchCardSingleGoingView(match: .sample)
          MatchCardSingleGoingView(match: .sampleWithCourtChange)
        }
      })
    .padding(.horizontal,12)
    .padding(.vertical,12)
    .background(Color.indigo)
    .previewInterfaceOrientation(.landscapeLeft)
  }
}
