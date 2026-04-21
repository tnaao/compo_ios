
//
//  ConfirmPopUpView.swift
//  CompoApp
//
//  Created by GH w on 3/19/26.
//

import AdapterSwift
import SwiftUI

struct ConfirmBeginMatchPopUpView: View {
  var setNumber:Int = 1
  var onConfirm: (() -> Void)?
  var onSkip: (() -> Void)?

  var body: some View {
    WarmupTimerPopupView(
      contentView: confirmContent,
      onConfirm: { _ in onConfirm?() },
      onSkip: onSkip,
      isCustomContent: true,
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

#Preview {
  ConfirmBeginMatchPopUpView()
    .previewInterfaceOrientation(.landscapeLeft)
}
