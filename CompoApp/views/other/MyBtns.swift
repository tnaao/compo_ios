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
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
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
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}


struct MyScorePlusBtn: View {
    var action:() -> Void = {}
    var body: some View {
        Button(action: {
          action()
        }) {
          Image(systemName: "plus")
                .font(.system(size: 50.adapter))
            .foregroundColor(.white)
            .frame(width: 73.adapter, height: 73.adapter)
            .background(Color(hex: "#FF848A98"))
            .clipShape(Circle())
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct MyScoreMinusBtn: View {
    var action:() -> Void = {}
    var body: some View {
        Button(action: {
          action()
        }) {
          Image(systemName: "minus")
                .font(.system(size: 50.adapter))
            .foregroundColor(.white)
            .frame(width: 73.adapter, height: 73.adapter)
            .background(Color(hex: "#FF848A98"))
            .clipShape(Circle())
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct BgAlertActions:View {
    var body: some View {
        HStack {
            Spacer().frame(maxHeight: .infinity).bgImage("alert_btn_bg_s1",contentMode: .fit)
                .offset(x: 2.adapter)
          Spacer().frame(maxHeight: .infinity).bgImage("alert_btn_bg_s2").offset(x: -2.adapter)
        }
    }
}


#Preview {
    VStack {
        MyScorePlusBtn {

        }
        MyScoreMinusBtn{
            
        }
        BgAlertActions().frame(height: 36.adapter)
    }
}

