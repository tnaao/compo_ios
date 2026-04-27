//
//  ScoreCenterView.swift
//  CompoApp
//
//  Created by GH w on 3/19/26.
//

import SwiftUI

struct ScoreCenterView: View {
    var body: some View {
        // 创建一个矩形，设置 frame
        RoundedRectangle(cornerRadius: 0) // 根据需要设置圆角，UIKit 代码中未指定则为直角
            .fill(
                // 对应：CAGradientLayer
                LinearGradient(
                    stops: [
                        .init(color: Color(red: 1, green: 0.59, blue: 0.16), location: 0),
                        .init(color: Color(red: 1, green: 0.89, blue: 0.8), location: 0.99)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0), // 对应：startPoint (0.5, 0)
                    endPoint: UnitPoint(x: 1, y: 1)     // 对应：endPoint (1, 1)
                )
            )
            .frame(width: 56, height: 45.5) // 对应：layerView.frame
            
            // 对应：shadowCode
            // 注意：SwiftUI 的 shadow radius 通常需要根据视觉效果微调，
            // UIKit 的 shadowRadius 5.6 在 SwiftUI 中通常直接对应 radius: 5.6
            .shadow(
                color: Color(red: 0.2, green: 0.08, blue: 0).opacity(0.3033),
                radius: 5.6,
                x: 0,
                y: -0.2 // 对应：shadowOffset (0, -0.2)
            )
            // 对应：layerView.frame 的位置 (x: 313.5, y: 313)
            // 注意：SwiftUI 的 position 是基于中心点的
            .position(x: 313.5 + 28, y: 313 + 22.75)
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}


@available(iOS 17.0, *)
#Preview {
    ScoreCenterView()
}
