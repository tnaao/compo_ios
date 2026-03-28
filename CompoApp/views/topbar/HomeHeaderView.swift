//
//  HomeHeaderView.swift
//  CompoApp
//
//  Created by GH w on 3/28/26.
//

import SwiftUI
import AdapterSwift

struct HomeHeaderView: View {
    var onLogout:()->Void
    var body: some View {
        ZStack(alignment: .center, content: {
                                Text("Zswing")
                                  .font(Font.custom("DouyinSans", size: 16.adapter))
                                  .foregroundColor(.black)
                                Button {
                                  //logout
                                  onLogout()
                                } label: {
                                    HStack(spacing: 0) {
                                        Spacer()
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .foregroundColor(Color(hex: "FF6E5DFF"))
                                            .frame(width: 12.adapter,height: 12.adapter)
                                        
                                        Text("退出")
                                            .foregroundStyle(Color.init(hex: "#FF3D3D3D"))
                                            .font(.system(size: 12.adapter))
                                            .padding(
                                                EdgeInsets(top: 0, leading: 4.adapter, bottom: 0, trailing: 12.adapter)
                                            )
                                            
                                    }.buttonStyle(.plain)
                                }

                            }).frame(height: 22.verticaldapter)
    }
}

struct HeaderPreviewView :View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear.ignoresSafeArea()
            HomeHeaderView(onLogout: {
                
            }).padding(.top,safeAreaInsets.top)
        }.loginBg()
    }
}

#Preview {
    RootView(rootDestination: .HeaderPreviewView)
}
