//
//  MatchCardActionHelper.swift
//  CompoApp
//
//  Created by GH w on 3/29/26.
//

import SwiftUI
import AdapterSwift

struct MatchCardActionsView: View {
    var isGoing:Bool = false
    var body: some View {
        VStack(spacing: 0) {
          Button(action: {}) {
            Text("重新签名")
                  .font(.system(size: 12.adapter, weight: .medium))
              .foregroundColor(.white)
              .frame(width: 100.adapter, height: 27.adapter)
              .background(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
              .clipShape(Capsule())
          }.noClickEffect().xVisible(!isGoing)
          Button(action: {}) {
            Text("计分")
                  .font(.system(size: 12.adapter, weight: .medium))
              .foregroundColor(.white)
              .frame(width: 100.adapter, height: 27.adapter)
              .background(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
              .clipShape(Capsule())
          }.noClickEffect().xVisible(isGoing)
            
            Spacer().fixedSize().frame(height: 15.verticaldapter)

          Button(action: {}) {
            Text("录入结果")
                  .font(.system(size: 12.adapter, weight: .medium))
              .foregroundColor(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
              .frame(width: 100.adapter, height: 27.adapter)
              .background(Color.white)
              .clipShape(Capsule())
              .overlay(
                Capsule()
                  .stroke(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255), lineWidth: 1)
              )
          }.noClickEffect()
        }
        .padding(.trailing, 24)
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

#Preview {
    Group {
        MatchCardActionsView(isGoing: true)
        MatchCardActionsView(isGoing: false)
    }
}
