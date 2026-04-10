import AdapterSwift
import SwiftUI

struct MatchScoringConfirmView: View {
    var title: String = "小学E组男子单打"
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            HStack(spacing: 0.adapter) {
                // Back Button
                LeadingBtn()
                
                Text(title)
                    .font(.system(size: 16.adapter, weight: .regular))
                    .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                
                Spacer()
                
                // Right Action Icons
                HStack(spacing: 16.adapter) {
                    // Badminton button
                    MyActionBtn(icon: "ball_01") {

                    }

                    // Pause button
                      MyActionBtn(icon: "action_pause") {

                      }

                    // Undo button
                      MyActionBtn(icon: "action_cancel") {

                      }
                    
                    // Swap button
                      MyActionBtn(icon: "action_change") {

                      }
                }
            }
            .frame(height: 40.adapter)
            .padding(.trailing, 20.adapter)
            
            // Main Content Area
            ZStack {
                VStack(spacing: 0) {
                    Spacer().frame(height: 10.adapter)
                    
                    // Big Scores Area
                    HStack(spacing: 40.adapter) {
                        // Left Score
                        HStack(alignment: .lastTextBaseline, spacing: 15.adapter) {
                            Text("6")
                                .font(.system(size: 110.adapter, weight: .bold))
                                .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))
                            
                            Text("0")
                                .font(.system(size: 80.adapter, weight: .medium))
                                .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))
                        }
                        
                        // Right Score
                        HStack(alignment: .lastTextBaseline, spacing: 15.adapter) {
                            Text("1")
                                .font(.system(size: 80.adapter, weight: .medium))
                                .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))
                            
                            Text("9")
                                .font(.system(size: 110.adapter, weight: .bold))
                                .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))
                        }
                    }
                    
                    Spacer().frame(height: 30.adapter)
                    
                    // Players & Center Status
                    HStack(alignment: .top, spacing: 50.adapter) {
                        
                        // Left Team
                        HStack(spacing: 15.adapter) {
                            ScoringPlayerCardView(name: "郑泽言", isChecked: true)
                            ScoringPlayerCardView(name: "余飞", isChecked: false)
                        }
                        
                        // Center Info
                        VStack(spacing: 6.adapter) {
                            Text("21:19")
                                .font(.system(size: 12.adapter, weight: .bold))
                                .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                            
                            Text("第1局 6:15")
                                .font(.system(size: 11.adapter, weight: .regular))
                                .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                            
                            Text("第2局 6:15")
                                .font(.system(size: 11.adapter, weight: .regular))
                                .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                        }
                        .padding(.top, 10.adapter)
                        
                        // Right Team
                        HStack(spacing: 15.adapter) {
                            ScoringPlayerCardView(name: "李泽凡", isChecked: true)
                            ScoringPlayerCardView(name: "马言", isChecked: true)
                        }
                    }
                    
                    Spacer()
                }
                
                // Bottom Layer Overlay
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        // Bottom Left Text Info
                        VStack(alignment: .center, spacing: 4.adapter) {
                            Text("郑泽言/余飞")
                                .font(.system(size: 12.adapter, weight: .bold))
                                .foregroundColor(Color(red: 250 / 255, green: 139 / 255, blue: 44 / 255)) // Orange
                            
                            Text("0:2")
                                .font(.system(size: 12.adapter, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("李泽凡/马言")
                                .font(.system(size: 12.adapter, weight: .bold))
                                .foregroundColor(Color(red: 250 / 255, green: 139 / 255, blue: 44 / 255)) // Orange
                            
                            Text("比分已成功上传")
                                .font(.system(size: 12.adapter, weight: .medium))
                                .foregroundColor(Color(red: 250 / 255, green: 139 / 255, blue: 44 / 255)) // Orange
                        }
                        .padding(.leading, 24.adapter)
                        .padding(.bottom, 24.adapter)
                        
                        Spacer()
                        
                        // Bottom Right Action Area
                        HStack(spacing: 8.adapter) {
                            // Winner Signature Button
                            Button(action: {
                                // actions
                            }) {
                                Text("胜方签名")
                                    .font(.system(size: 14.adapter, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 90.adapter, height: 36.adapter)
                                    .background(
                                        SlantedButtonShape(type: .leftRoundedRightSlanted, slantOffset: 12.adapter)
                                            .fill(Color(red: 255 / 255, green: 90 / 255, blue: 90 / 255))
                                    )
                            }.noClickEffect()
                            
                            // Close Button
                            Button(action: {
                                // actions
                            }) {
                                Text("关闭")
                                    .font(.system(size: 14.adapter, weight: .medium))
                                    .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                                    .frame(width: 90.adapter, height: 36.adapter)
                                    .background(
                                        SlantedButtonShape(type: .bothSlanted, slantOffset: 12.adapter)
                                            .fill(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255)) // Light Gray
                                    )
                            }.noClickEffect()
                            
                            // Referee Signature Button
                            Button(action: {
                                // actions
                            }) {
                                Text("裁判签名")
                                    .font(.system(size: 14.adapter, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 90.adapter, height: 36.adapter)
                                    .background(
                                        SlantedButtonShape(type: .leftSlantedRightRounded, slantOffset: 12.adapter)
                                            .fill(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
                                    )
                            }.noClickEffect()
                        }
                        .padding(.trailing, 24.adapter)
                        .padding(.bottom, 24.adapter)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .loginBg()
        .ignoresSafeArea(.all, edges: .bottom)
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

// Player Card for Scoring View
struct ScoringPlayerCardView: View {
    var name: String
    var isChecked: Bool
    var avatar:String?  = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Main Card Body
            VStack(spacing: 6.adapter) {
                // Mock Avatar (can use PlayerIconView if available)
                PlayerIconView(url: avatar, hasWinnerBadge: false,size: 28.adapter)
                
                Text(name)
                    .font(.system(size: 10.adapter, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 55.adapter, height: 75.adapter)
            .background(Color(red: 130 / 255, green: 110 / 255, blue: 240 / 255)) // Purple card bg
            .cornerRadius(4.adapter)
            
            // "已检" Badge
            if isChecked {
                Text("已检")
                    .font(.system(size: 8.adapter))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4.adapter)
                    .padding(.vertical, 2.adapter)
                    .background(Color(red: 100 / 255, green: 80 / 255, blue: 200 / 255)) // Darker purple badge
                    .cornerRadius(2.adapter, corners: [.topRight, .bottomLeft])
            }
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct MatchScoringConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        MatchScoringConfirmView()
            .previewInterfaceOrientation(.landscapeLeft)
            .background(Color.gray.opacity(0.1)) // Outline check
    }
}
