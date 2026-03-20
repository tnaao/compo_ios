//
//  ViewUtil.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//

import SwiftUI
import AdapterSwift

extension View {
  func loginBg() -> some View {
      bgImage("loginBg")
    }
}

extension View {
      func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
      }
    
      func hideNavigationBar() -> some View {
          self.toolbarVisibility(.hidden, for: .navigationBar)
      }
    
    func bgImage(_ name:String) -> some View {
        return ZStack {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
            self
        }
    }
    
    @ViewBuilder
    func xVisible(_ v:Bool) -> some View {
        if v {
            self
        } else {
            EmptyView()
        }
    }
       
    @ViewBuilder
    func xDisplay(_ v: Bool) -> some View {
        if v {
            self.opacity(1.0)
        } else {
            self.opacity(0.0)
        }
    }
    
    @ViewBuilder
    func xShadow(radius:CGFloat=2,bgColor:Color = .clear,blur:CGFloat = 0,blurColor:Color = .clear,innerBorderWidth:CGFloat=0,innerBorderColor:Color = .clear,outerBorderWidth:CGFloat = 0,outerBorderColor:Color = .clear) -> some View{
        
        let hassInnerBorder = innerBorderWidth > 0
        ZStack {
            RoundedRectangle(cornerRadius: radius.adapter) // 对应：圆角 2pt
                .fill(bgColor) // 对应：填充颜色 #4DFFFFFF
                .overlay(
                                // 使用 strokeBorder 确保边框向内绘制
                                RoundedRectangle(cornerRadius: radius)
                                    .strokeBorder(Color.white, lineWidth: innerBorderWidth)
                            )
            // 1. 外边框 (Stroke)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(outerBorderColor, lineWidth: outerBorderWidth) // 对应：粗细 0.5pt, 颜色 #FFFFFFFF
                )
            
            // 2. 外阴影 (Outer Shadow)
            // SwiftUI 的 radius 等于设计稿 blur 的一半（近似算法），Spread 需通过 padding 或 inset 模拟
                .shadow(
                    color: blurColor, // 对应：阴影颜色 #14000000
                    radius: blur / 2, // 对应：Effect blur 5.5pt
                    x: 2,           // 对应：Offset X 2pt
                    y: 3            // 对应：Offset Y 3pt
                )
            
            GeometryReader { geoReader in
                self
            }
        }
    }
    
    func noClickEffect() -> some View {
        self.buttonStyle(NoPressEffectStyle())
    }
}

struct NoPressEffectStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // The following line ensures no change in appearance based on the pressed state
            // If you did want an effect, you'd use configuration.isPressed
            .opacity(1.0)
    }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

