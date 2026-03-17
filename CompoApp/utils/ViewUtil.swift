//
//  ViewUtil.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//

import SwiftUI
import AdapterSwift

extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
    
  func loginBg() -> some View {
      return ZStack {
          Image("bgLogin")
              .resizable()
            .aspectRatio(contentMode: .fill)
          self
      }
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
