//
//  ConfirmPopUpView.swift
//  CompoApp
//
//  Created by GH w on 3/19/26.
//

import AdapterSwift
import SwiftUI

struct ConfirmPopUpView: View {
  var onConfirm: (() -> Void)?
  var onSkip: (() -> Void)?

  var body: some View {
    WarmupTimerPopupView(
      contentView: confirmContent,
      onConfirm: { _ in onConfirm?() },
      onSkip: onSkip,
      isCustomContent: true,
    )
  }

  private var confirmContent: some View {
    VStack(spacing: 12.adapter) {
      Spacer()

      // Title
      Text("确认结束比赛吗？")
        .font(.system(size: 18.adapter, weight: .semibold))
        .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))

      // Subtitle
      Text("已有一方分数达到封顶21分，请与选手确认成绩")
        .font(.system(size: 14.adapter))
        .foregroundColor(Color(red: 255 / 255, green: 140 / 255, blue: 0 / 255))
        .multilineTextAlignment(.center)

      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  ConfirmPopUpView()
    .previewInterfaceOrientation(.landscapeLeft)
}
