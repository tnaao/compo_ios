import AdapterSwift
import SwiftUI

struct EarlyEndMatchPopUpView: View {
  var winnerName: String
  var onConfirm: (() -> Void)?
  var onSkip: (() -> Void)?

  // Match data
  var courtName: String = ""
  var matchNumber: String = ""
  
  var team1ClubName: String = ""
  var team1SetPoints: Int = 0
  var team1PlayerNames: String = ""
  var team1Points: Int = 0
  
  var team2ClubName: String = ""
  var team2SetPoints: Int = 0
  var team2PlayerNames: String = ""
  var team2Points: Int = 0
    var cancelText:String = "继续"
  
  var body: some View {
    WarmupTimerPopupView(
      contentView: confirmContent,
      onConfirm: { _ in onConfirm?() },
      onSkip: onSkip,
      isCustomContent: true,
      courtName: courtName,
      matchNumber: matchNumber,
      team1ClubName: team1ClubName,
      team1SetPoints: team1SetPoints,
      team1PlayerNames: team1PlayerNames,
      team1Points: team1Points,
      team2ClubName: team2ClubName,
      team2SetPoints: team2SetPoints,
      team2PlayerNames: team2PlayerNames,
      team2Points: team2Points,
      cancelText: cancelText
    )
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif

  private var confirmContent: some View {
    VStack(spacing: 12.adapter) {
      Spacer()

      // Title
      Text("\(winnerName)已连胜2局")
        .font(.system(size: 18.adapter, weight: .semibold))
        .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))

      // Subtitle
      Text("是否直接结束整场比赛？")
        .font(.system(size: 14.adapter))
        .foregroundColor(Color(red: 255 / 255, green: 140 / 255, blue: 0 / 255))
        .multilineTextAlignment(.center)

      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
    EarlyEndMatchPopUpView(winnerName: "余苇航/吴威航")
    .previewInterfaceOrientation(.landscapeLeft)
}
