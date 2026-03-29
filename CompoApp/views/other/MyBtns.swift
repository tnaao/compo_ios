//
//  MyBtns.swift
//  CompoApp
//
//  Created by GH w on 3/19/26.
//

import SwiftUI
import AdapterSwift

struct MyActionBtn: View {
    let icon:String
    var action:() -> Void = {}
    var body: some View {
        Button(action: action) {
            MyAssetImage(name: icon,width: 25.adapter, height: 25.adapter,contentMode: .fit)
        }.buttonStyle(.plain)
    }
}

struct LeadingBtn:View {
    @Environment(\.dismiss) var dismiss
    var action:(()->Void)? = nil
    var body: some View {
        Button(action: {
            if action == nil {
                dismiss()
            }else {
                action?()
            }
        }) {
            MyAssetImage(name: "btnBack",width: 15.adapter,height: 15.adapter)
                .padding(.leading,16.adapter)
                .padding(.trailing,8.adapter)
        }
    }
}


struct MyScorePlusBtn: View {
    var action:() -> Void = {}
    var body: some View {
        Button(action: {
          action()
        }) {
          Image(systemName: "plus")
            .font(.system(size: 32, weight: .light))
            .foregroundColor(.white)
            .frame(width: 73.adapter, height: 73.adapter)
            .background(Color(hex: "#FF9E9E9E"))
            .clipShape(Circle())
        }
    }
}

