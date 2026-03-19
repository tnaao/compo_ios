//
//  MyAssetImage.swift
//  zswing
//
//  Created by GH w on 3/17/26.
//

import SwiftUI

struct MyAssetImage: View {
    var name:String = "icon"
    var width:CGFloat = 50
    var height:CGFloat = 50
    var contentMode:ContentMode = .fit
    var bgColor:Color? = .clear
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: contentMode, )
            .frame(width: width, height: height)
            .background(bgColor ?? Color.gray.opacity(0.1))
    }
}

#Preview {
    MyAssetImage(name:  "icon")
}
