import AdapterSwift
import SwiftUI

// MARK: - Event Log Model
struct MatchEventItem: Identifiable {
  let id = UUID()
  let index: Int
  let name: String
  let player: String
  let time: String
}

// MARK: - Match Event Log Popup
struct MatchEventLogPopupView: View {
  // Callbacks
  var onClose: (() -> Void)?
  var onDelete: ((MatchEventItem) -> Void)?

  // Match data
  let courtName: String
  let team1Name: String
  let team1SetPoints: Int
  let team1Player: String
  let team1Score: String
  let team1IsServing: Bool
  let team1NotificationCount: Int

  let matchNumber: String
  let team2Name: String
  let team2SetPoints: Int
  let team2Player: String
  let team2Score: String
  let team2IsServing: Bool

  // Event list data
  let events: [MatchEventItem]

  var body: some View {
    ZStack {
      // Dark Overlay
      Color.black.opacity(0.4)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture { onClose?() }

      // Modal Container
      VStack(spacing: 0) {

        // Top Match Info Section (Gradient Background)
        ZStack(alignment: .topTrailing) {
          VStack(spacing: 8.adapter) {
            // Row 1
            HStack(spacing: 8.adapter) {
              // Team 1 Label
              Text(courtName)
                .font(.system(size: 11.adapter))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 10.adapter)
                .frame(width: 103.adapter, height: 30.adapter)
                .background(Color(red: 126 / 255, green: 96 / 255, blue: 254 / 255))
                .cornerRadius(4.adapter)

              // Set Points
              Text("\(team1SetPoints)")
                .font(.system(size: 16.adapter, weight: .bold))
                .foregroundColor(Color(red: 255 / 255, green: 65 / 255, blue: 55 / 255))
                .frame(width: 20.adapter)

              // Player 1 name + serving arrow
              HStack(spacing: 4.adapter) {
                Text(team1Player)
                  .font(.system(size: 11.adapter))
                  .foregroundColor(.white)
                if team1IsServing {
                  Text("◀")
                    .font(.system(size: 9.adapter))
                    .foregroundColor(.white)
                }
              }
              .frame(width: 70.adapter, height: 30.adapter)
              .background(Color(red: 126 / 255, green: 96 / 255, blue: 254 / 255))
              .cornerRadius(4.adapter)

              // Scores
              Text(team1Score)
                .font(.system(size: 16.adapter, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 52.adapter)

              // Notification badge for team 1
              ZStack(alignment: .topTrailing) {
                MyAssetImage(name: "ball_01")
                      .padding(.all,2.adapter)
                  .frame(width: 28.adapter, height: 28.adapter)
                if team1NotificationCount > 0 {
                  Text("\(team1NotificationCount)")
                    .font(.system(size: 9.adapter, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 14.adapter, height: 14.adapter)
                    .background(Color(red: 76 / 255, green: 175 / 255, blue: 80 / 255))
                    .clipShape(Circle())
                    .offset(x: 4.adapter, y: -4.adapter)
                }
              }
              .frame(width: 34.adapter, height: 34.adapter)
            }

            // Row 2
            HStack(spacing: 8.adapter) {
              // Match number label
              Text(matchNumber)
                .font(.system(size: 11.adapter))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 10.adapter)
                .frame(width: 103.adapter, height: 30.adapter)
                .background(Color(red: 126 / 255, green: 96 / 255, blue: 254 / 255))
                .cornerRadius(4.adapter)

              // Set Points
              Text("\(team2SetPoints)")
                .font(.system(size: 16.adapter, weight: .bold))
                .foregroundColor(Color(red: 255 / 255, green: 65 / 255, blue: 55 / 255))
                .frame(width: 20.adapter)

              // Player 2 name + serving arrow
              HStack(spacing: 4.adapter) {
                Text(team2Player)
                  .font(.system(size: 11.adapter))
                  .foregroundColor(.white)
                if team2IsServing {
                  Text("◀")
                    .font(.system(size: 9.adapter))
                    .foregroundColor(.white)
                }
              }
              .frame(width: 70.adapter, height: 30.adapter)
              .background(Color(red: 126 / 255, green: 96 / 255, blue: 254 / 255))
              .cornerRadius(4.adapter)

              // Scores
              Text(team2Score)
                .font(.system(size: 16.adapter, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 52.adapter)

              // Placeholder to align with badge above
              Color.clear.frame(width: 34.adapter, height: 34.adapter)
            }
          }
          .padding(.horizontal, 20.adapter)
          .padding(.vertical, 18.adapter)
          .frame(maxWidth: .infinity)

          // Close Button (top-right)
          Button(action: { onClose?() }) {
            ZStack {
              Circle()
                .stroke(Color(red: 180 / 255, green: 180 / 255, blue: 190 / 255), lineWidth: 1.5.adapter)
                .frame(width: 28.adapter, height: 28.adapter)
              Image(systemName: "xmark")
                .font(.system(size: 11.adapter, weight: .semibold))
                .foregroundColor(Color(red: 120 / 255, green: 120 / 255, blue: 130 / 255))
            }
          }
          .padding(.top, 12.adapter)
          .padding(.trailing, 12.adapter)
        }
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

        // Bottom White Section - Event Table
        VStack(spacing: 0) {
          Spacer().frame(height: 16.adapter)

          // Table Header
          HStack(spacing: 0) {
            EventTableCell(text: "序号", isHeader: true, flex: 1)
            EventTableCell(text: "名称", isHeader: true, flex: 1)
            EventTableCell(text: "选手", isHeader: true, flex: 1)
            EventTableCell(text: "时间", isHeader: true, flex: 2)
            EventTableCell(text: "操作", isHeader: true, flex: 1)
          }
          .frame(maxWidth: .infinity)
          .background(Color.white)
          .overlay(
            Rectangle()
                .stroke(Color(hex:"#806E5DFF"), lineWidth: 0.5.adapter)
          )
          .padding(.horizontal, 20.adapter)

          // Table Rows
          ForEach(events) { event in
            HStack(spacing: 0) {
              EventTableCell(text: "\(event.index)1", isHeader: false, flex: 1)
              EventTableCell(text: event.name, isHeader: false, flex: 1)
              EventTableCell(text: event.player, isHeader: false, flex: 1)
              EventTableCell(text: event.time, isHeader: false, flex: 2)
              // Delete action cell
              Button(action: { onDelete?(event) }) {
                Text("删除")
                  .font(.system(size: 13.adapter))
                  .foregroundColor(Color(red: 255 / 255, green: 80 / 255, blue: 80 / 255))
                  .frame(maxHeight: .infinity)
              }
              .frame(maxWidth: .infinity)
              .frame(height: 40.adapter)
              .overlay(
                Rectangle()
                  .stroke(Color(hex: "#806E5DFF"), lineWidth: 0.5.adapter)
              )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20.adapter)
          }

          Spacer().frame(height: 24.adapter)
            
            Button(action: {  }) {
              Text("删除")
                .font(.system(size: 13.adapter))
                .foregroundColor(Color(red: 255 / 255, green: 80 / 255, blue: 80 / 255))
                .frame(maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40.adapter)
              .overlay(
                Rectangle()
                  .stroke(Color(red: 220 / 255, green: 220 / 255, blue: 225 / 255), lineWidth: 0.5.adapter)
              ).padding(.horizontal,20.adapter)
              .layoutPriority(1)
            
            
            Spacer().frame(height: 24.adapter)
        }
        .background(Color.white)
      }
      .frame(width: 417.adapter)
      .cornerRadius(14.adapter)
      .shadow(color: Color.black.opacity(0.15), radius: 14.adapter, x: 0, y: 6.adapter)
    }
    .transition(.opacity.combined(with: .scale(scale: 0.95)))
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// MARK: - Table Cell Helper
private struct EventTableCell: View {
  let text: String
  let isHeader: Bool
  let flex: Int

  var body: some View {
    Text(text)
      .font(.system(size: isHeader ? 13.adapter : 13.adapter, weight: isHeader ? .regular : .regular))
      .foregroundColor(isHeader ? Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255) : Color(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
      .frame(maxWidth: .infinity, minHeight: 40.adapter)
      .overlay(
        Rectangle()
          .stroke(Color(hex: "#806E5DFF"), lineWidth: 0.5.adapter)
      )
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// MARK: - Preview
#Preview(traits: .landscapeLeft) {
  MatchEventLogPopupView(
    onClose: {},
    onDelete: { _ in },
    courtName: "场地8",
    team1Name: "场地8",
    team1SetPoints: 0,
    team1Player: "余苇航",
    team1Score: "06  06",
    team1IsServing: false,
    team1NotificationCount: 1,
    matchNumber: "第13场",
    team2Name: "萧山羽飞",
    team2SetPoints: 1,
    team2Player: "郑泽言",
    team2Score: "15  09",
    team2IsServing: true,
    events: [
      MatchEventItem(index: 1, name: "换球", player: "—", time: "11:21:03"),
    ]
  )
}
