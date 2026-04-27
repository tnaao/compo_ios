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
    var resign:()->Void = {}
    var scoring:()->Void = {}
    var inputResult:()->Void = {}
    var notifyFn:()->Void = {}
    var body: some View {
        VStack(spacing: 15.verticaldapter) {
          Button(action: {
              resign()
          }) {
            Text("重新签名")
                  .font(.system(size: 12.adapter, weight: .medium))
              .foregroundColor(.white)
              .frame(width: 100.adapter, height: 27.adapter)
              .background(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
              .clipShape(Capsule())
          }.noClickEffect().xVisible(!isGoing)
          Button(action: {
              scoring()
          }) {
            Text("计分")
                  .font(.system(size: 12.adapter, weight: .medium))
              .foregroundColor(.white)
              .frame(width: 100.adapter, height: 27.adapter)
              .background(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
              .clipShape(Capsule())
          }.noClickEffect().xVisible(isGoing)
            
          Button(action: {
              inputResult()
          }) {
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
            
            
            Button(action: {
                notifyFn()
            }) {
                Text("消息通知")
                      .font(.system(size: 12.adapter, weight: .medium))
                  .foregroundColor(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
                  .frame(width: 100.adapter, height: 27.adapter)
                  .background(Color.white)
                  .clipShape(Capsule())
                  .overlay(
                    Capsule()
                      .stroke(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255), lineWidth: 1)
                  )
            }.noClickEffect().xVisible(isGoing)
        }
        .padding(.trailing, 24)
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

@available(iOS 17.0, *)
#Preview {
    Group {
        MatchCardActionsView(isGoing: true)
        MatchCardActionsView(isGoing: false)
    }
}
