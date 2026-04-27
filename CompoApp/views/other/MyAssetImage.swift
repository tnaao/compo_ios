//
//  MyAssetImage.swift
//  zswing
//
//  Created by GH w on 3/17/26.
//

import SwiftUI
import AdapterSwift

struct MyAssetImage: View {
    var name:String = "icon"
    var width:CGFloat = 50
    var height:CGFloat = 50
    var contentMode:ContentMode = .fit
    var bgColor:Color? = .clear
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: contentMode,)
            .frame(width: width, height: height)
            .clipped()
            .background(bgColor ?? Color.gray.opacity(0.1))
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

@available(iOS 17.0, *)
#Preview {
    MyAssetImage(name:  "brCircleBg"
                 ,width: 100.adapter,height: 100.adapter,contentMode: .fit,bgColor: Color.clear)
}
