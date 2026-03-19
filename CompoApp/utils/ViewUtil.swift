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
      return ZStack {
          Image("bgLogin")
              .resizable()
            .aspectRatio(contentMode: .fill)
          self
      }
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

