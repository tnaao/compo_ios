
//
//  ConfirmPopUpView.swift
//  CompoApp
//
//  Created by GH w on 3/19/26.
//

import AdapterSwift
import SwiftUI

struct ConfirmBeginMatchPopUpView: View {
  var setNumber: Int = 1
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
      team2Points: team2Points
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
      Text("确认开始第\(setNumber)局比赛吗？")
        .font(.system(size: 18.adapter, weight: .semibold))
        .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))

      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

@available(iOS 17.0, *)
#Preview(traits: .landscapeLeft) {
  ConfirmBeginMatchPopUpView()
}
