//
//  LoginView.swift
//  CompoApp
//
//  Created by GH w on 3/16/26.
//

import AdapterSwift
import SwiftUI

struct LoginView: View {
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @StateObject private var vm = LoginVm()
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case phone, code
    }

  var body: some View {
      ZStack(alignment: .center) {
      // Background gradient
        Color.clear.loginBg()
      .ignoresSafeArea()
        
        VStack(alignment: .leading) {
            HStack {
                LeadingBtn().padding(.top,safeAreaInsets.top)
                Spacer()
            }
            Spacer()
        }

      // Main card
      VStack(spacing: 0) {
        // Logo
        ZStack {
            MyAssetImage(name: "loginLogo",width: 50.adapter, height: 50.adapter).zIndex(2)

          // Zswing logo with diagonal stripe
          ZStack {
            // Diagonal purple stripe
            Rectangle()
              .fill(
                LinearGradient(
                  gradient: Gradient(colors: [
                    Color(red: 0.45, green: 0.40, blue: 0.95),
                    Color(red: 0.55, green: 0.50, blue: 1.0),
                  ]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(width: 60, height: 20)
              .rotationEffect(.degrees(-30))
              .cornerRadius(2).xVisible(false)

            Text("Zswing")
              .font(Font.custom("DouyinSans", size: 12.adapter))
              .foregroundColor(.black).xVisible(false)
          }
        }.frame(width:50.adapter, height: 50.adapter)
        .padding(.top, 12.adapter)

        // Welcome text
        Text("欢迎来到Zswing裁判端登录界面")
          .font(Font.custom("DouyinSans", size: 12.adapter))
          .foregroundColor(Color(hex: "#FF333333"))
          .padding(.top, 11.5.adapter)

        // Phone number input
        HStack(spacing: 12) {
          Image("etPhone")
            .resizable()
            .scaledToFit()
            .frame(width: 10.adapter, height: 10.adapter)

          TextField("请输入手机号", text: $vm.phoneNumber)
                .font(.system(size: 10.adapter))
                .focused($focusedField, equals: .phone)
            .keyboardType(.phonePad)
        }
        .padding(.horizontal, 16)
        .frame(width: 190.adapter, height: 30.adapter)
        .background(Color.white)
        .cornerRadius(41.adapter)
        .padding(.top, 21.5.adapter)
        .onTapGesture {
            focusedField = .phone
        }

        // Verification code input
        HStack(spacing: 12) {
          Image("etPassword")
            .resizable()
            .scaledToFit()
            .frame(width: 10.adapter, height: 10.adapter)
            .foregroundColor(Color.gray)

          TextField("请输入验证码", text: $vm.verificationCode)
                .font(.system(size: 10.adapter))
                .focused($focusedField, equals: .code)
            .keyboardType(.numberPad)
        }
        .padding(.horizontal, 16)
        .frame(width: 190.adapter, height: 30.adapter)
        .background(Color.white)
        .cornerRadius(41.adapter)
        .padding(.top, 8.adapter)
        .onTapGesture {
            focusedField = .code
        }

        Spacer()

        // Login button
        Button(action: {
          vm.login()
        }) {
          if vm.isLoading {
              ProgressView()
                  .progressViewStyle(CircularProgressViewStyle(tint: .white))
          } else {
              Text("立即登录")
                  .font(.system(size: 14.adapter, weight: .medium))
                .foregroundColor(.white).frame(width: 190.adapter, height: 30.adapter)
                .background(
                  Color(hex: vm.isLoading ? "#FFAAAAAA" : "#FF887BF7")
                )
          }
        }
        .disabled(vm.isLoading)
        .frame(width: 190.adapter, height: 30.adapter)
        .background(
          Color(hex: vm.isLoading ? "#FFAAAAAA" : "#FF887BF7")
        )
        .cornerRadius(41.adapter)
        .padding(.bottom, 22.adapter)
      }
      .frame(width: 251.adapter, height: 260.adapter)
      .blur(radius: 0.4)
      .background(Color(hex: "#4DFFFFFF"))
      .overlay(
        RoundedRectangle(cornerRadius: 12.4.adapter)
          .stroke(Color.white, lineWidth: 1.24)
      )
      .clipShape(RoundedRectangle(cornerRadius: 12.4.adapter))

    }
      .onAppear {
          // Auto-focus phone number field when view appears
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              focusedField = .phone
          }
      }
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

@available(iOS 17.0, *)
#Preview {
  RootView()
}
