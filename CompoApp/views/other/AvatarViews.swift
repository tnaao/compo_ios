//
//  AvatarViews.swift
//  CompoApp
//
//  Created by GH w on 3/19/26.
//

import SwiftUI
import AdapterSwift

struct PlayerCourtInfoView: View {
    var name: String = "小李"
    var iconUrl = "https://raw.githubusercontent.com/ghw001/CompoApp/main/Assets/avatar.png"
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 2.adapter) // 对应：圆角 2pt
                .fill(Color(hex: "#4DFFFFFF")) // 对应：填充颜色 #4DFFFFFF
                .frame(width: 47.adapter, height: 59.adapter)
            
            // 1. 外边框 (Stroke)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color(hex: "#FFFFFFFF"), lineWidth: 0.5) // 对应：粗细 0.5pt, 颜色 #FFFFFFFF
                )
            
            // 2. 外阴影 (Outer Shadow)
            // SwiftUI 的 radius 等于设计稿 blur 的一半（近似算法），Spread 需通过 padding 或 inset 模拟
                .shadow(
                    color: Color(hex: "#14000000"), // 对应：阴影颜色 #14000000
                    radius: 5.5 / 2, // 对应：Effect blur 5.5pt
                    x: 2,           // 对应：Offset X 2pt
                    y: 3            // 对应：Offset Y 3pt
                )
            
         
            
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer().frame(height: 1)
                    Text("已检").font(.system(size: 8.5.adapter)).foregroundStyle(.white)
                        .frame(
                            width: 24.adapter,height: 12.adapter
                        ).background(Color(hex: "#33000000"))
                }.frame(width: 48.adapter)
                
                MyNetImage(url: iconUrl, width: 25.adapter,height: 25.adapter,isOval: true)
                    .innerBorderCircle(color: Color.white, lineWidth: 3.adapter)
                    .playerIconShadow(size: 25.adapter)
                    
                
                
                Spacer().fixedSize().frame(height: 4.adapter)
                
                Text(name).font(.system(size: 8.5.adapter)).foregroundStyle(.white)
            }
            
        }.frame(width: 48.adapter, height: 60.adapter)
            .clipShape(RoundedRectangle(cornerRadius: 2.adapter))
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}


struct PlayerIconView:View {
    var url:String? = nil
    let hasWinnerBadge:Bool
    var size:CGFloat = 35.adapter
    var body: some View {
        ZStack(alignment: .topLeading) {
            MyNetImage(url: url,width: size,height: size,isOval: true)
                .innerBorderCircle(color: Color.white, lineWidth: size < 35.adapter ? 2.adapter : 4.adapter)
                .playerIconShadow(size: size,)

          if hasWinnerBadge {
            MyAssetImage(
                name: "playerWinnerTag",
                width: 19.adapter,
                height: 19.adapter
            )
              .offset(x: -6.adapter, y: -6.adapter)
          }
        }.frame(width: size,height: size)
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

#Preview {
    VStack(spacing: 20.adapter) {
        PlayerIconView(url: nil, hasWinnerBadge: true)
        PlayerCourtInfoView()
    }
}
