//
//  ViewWidget.swift
//  CompoApp
//
//  Created by GH w on 3/19/26.
//

import SwiftUI
import AdapterSwift


extension View {
    
    func bgWhiteGray() -> some View {
        background(content:{
            VStack(spacing: 0) {
                            Color.white // 上半部分颜色
                            Color(hex: "#FFE4E4E4") // 下半部分颜色（示例中的浅灰色）
             }
        }).frame(height: 22.adapter).cornerRadius(2.adapter)
            .shadow(color: Color.black.opacity(0.05), radius: 2.adapter, x: 0, y: 2.adapter)
    }
}
