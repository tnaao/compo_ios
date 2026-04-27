import AdapterSwift
import SwiftUI

struct MatchSignatureScoringConfirmView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var scoreStore:MatchScoringStore = MatchScoringStore.shared
    
    // Computed properties for data binding
    var team1Name: String {
        scoreStore.currentMatch?.pair1List?.map { $0.playerName }.joined(separator: "/") ?? "队伍1"
    }

    var team2Name: String {
        scoreStore.currentMatch?.pair2List?.map { $0.playerName }.joined(separator: "/") ?? "队伍2"
    }

    var team1CurrentScore: Int {
        Int(scoreStore.scoreDetail?.getSetScore(by: scoreStore.currentSetNumber)?.player1Score ?? 0)
    }

    var team2CurrentScore: Int {
        Int(scoreStore.scoreDetail?.getSetScore(by: scoreStore.currentSetNumber)?.player2Score ?? 0)
    }

    var team1SetScore: Int {
        Int(scoreStore.scoreDetail?.pair1Score ?? scoreStore.currentMatch?.pair1Score ?? 0)
    }

    var team2SetScore: Int {
        Int(scoreStore.scoreDetail?.pair2Score ?? scoreStore.currentMatch?.pair2Score ?? 0)
    }
    var isSwapped: Bool {
        scoreStore.courtSwapped == 1
    }

    var leftTeamName: String {
        isSwapped ? team2Name : team1Name
    }

    var rightTeamName: String {
        isSwapped ? team1Name : team2Name
    }

    var leftTeamCurrentScore: Int {
        isSwapped ? team2CurrentScore : team1CurrentScore
    }

    var rightTeamCurrentScore: Int {
        isSwapped ? team1CurrentScore : team2CurrentScore
    }

    var leftTeamSetScore: Int {
        isSwapped ? team2SetScore : team1SetScore
    }

    var rightTeamSetScore: Int {
        isSwapped ? team1SetScore : team2SetScore
    }
    
    var leftList: [PlayerItemModel]? {
        isSwapped ? scoreStore.currentMatch?.pair2List : scoreStore.currentMatch?.pair1List
    }

    var rightList: [PlayerItemModel]? {
        isSwapped ? scoreStore.currentMatch?.pair1List : scoreStore.currentMatch?.pair2List
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            navigationBar.padding(.top, safeAreaInsets.top)
            // Score Board
            scoreBoard
              .padding(.top, 20.adapter)
              .padding(.bottom, 25.adapter)
            // Main Content Area
            ZStack {
                VStack(spacing: 0) {
                    // Big Scores Area
                    HStack(spacing: 40.adapter) {
                        // Left Score
                        HStack(alignment: .lastTextBaseline, spacing: 15.adapter) {
                            Text("\(leftTeamCurrentScore)")
                                .font(.system(size: 110.adapter, weight: .bold))
                                .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))
                            
                            Text("\(leftTeamSetScore)")
                                .font(.system(size: 80.adapter, weight: .medium))
                                .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))
                        }
                        
                        // Right Score
                        HStack(alignment: .lastTextBaseline, spacing: 15.adapter) {
                            Text("\(rightTeamSetScore)")
                                .font(.system(size: 80.adapter, weight: .medium))
                                .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))
                            
                            Text("\(rightTeamCurrentScore)")
                                .font(.system(size: 110.adapter, weight: .bold))
                                .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))
                        }
                    }.xVisible(false)
                                        
                    // Players & Center Status
                    HStack(alignment: .top, spacing: 50.adapter) {
                        
                        // Left Team
                        HStack(spacing: 15.adapter) {
                            if let list = leftList {
                                ForEach(list, id: \.playerId) { p in
                                    ScoringPlayerCardView(name: p.playerName, isChecked: true, avatar: p.avatar)
                                }
                            }
                        }
                        
                        // Center Info
                        VStack(spacing: 6.adapter) {
                            Text("\(team1CurrentScore):\(team2CurrentScore)")
                                .font(.system(size: 12.adapter, weight: .bold))
                                .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                            
                            if let detailList = scoreStore.scoreDetail?.scoreDetailList {
                                ForEach(detailList) { round in
                                    if let rNum = round.roundNumber {
                                        Text("第\(rNum)局 \(round.player1Score ?? 0):\(round.player2Score ?? 0)")
                                            .font(.system(size: 11.adapter, weight: .regular))
                                            .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                                    }
                                }
                            }
                        }
                        .padding(.top, 10.adapter)
                        
                        // Right Team
                        HStack(spacing: 15.adapter) {
                            if let list = rightList {
                                ForEach(list, id: \.playerId) { p in
                                    ScoringPlayerCardView(name: p.playerName, isChecked: true, avatar: p.avatar)
                                }
                            }
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
                            Text(team1Name)
                                .font(.system(size: 12.adapter, weight: .bold))
                                .foregroundColor(Color(red: 250 / 255, green: 139 / 255, blue: 44 / 255)) // Orange
                            
                            Text("\(team1SetScore):\(team2SetScore)")
                                .font(.system(size: 12.adapter, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(team2Name)
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
                                AppRouter.shared.appRouter.navigateTo(.matchSignature(role: "winner"))
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
                                AppRouter.shared.appRouter.popNavigation()
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
                                AppRouter.shared.appRouter.navigateTo(.matchSignature(role: "referee"))
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
        .onAppear(perform: {
            scoreStore.fetchMatchScoreDetail(matchNo: scoreStore.currentMatch?.matchNo ?? "0")
        })
        .ignoresSafeArea(.all, edges: .bottom)
        .enableInjection()
    }
    
#if DEBUG
    @ObserveInjection var forceRedraw
#endif
    
 
    // MARK: - Score Board
    private var scoreBoard: some View {
        VStack(spacing: 0) {
            // Match type badge
            Text(scoreStore.currentMatch?.matchType ?? "")
                .font(.system(size: 10.adapter, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24.adapter)
                .padding(.vertical, 6.adapter)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "#FF6E5DFF"))
                )
                .zIndex(1)
            
            HStack(spacing: 0) {
                // Team Left
                Text(leftTeamName)
                    .font(.system(size: 16.adapter, weight: .medium))
                    .foregroundColor(Color(hex: "#FF222429")).frame(maxWidth: .infinity)
                // VS
                Text("VS")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12.adapter)
                    .padding(.vertical, 4.adapter)
                    .background(Color(hex: "#FF6E5DFF"))
                    .cornerRadius(4.adapter)
                // Team Right
                Text(rightTeamName)
                    .font(.system(size: 16.adapter, weight: .medium))
                    .foregroundColor(Color(hex: "#FF222429")).frame(maxWidth: .infinity)
            }
            .bgWhiteGray()
            .padding(.horizontal, 45.adapter)
        }
    }

    
    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack(spacing: 0) {
            LeadingBtn()
            
            Text(scoreStore.currentMatch?.eventName ?? "")
                .font(.system(size: 10.adapter, weight: .medium))
                .foregroundColor(Color(hex: "#FF222429"))
            
            Spacer()
            // Action buttons
            HStack(spacing: 12.adapter) {
                // Badminton button
                MyActionBtn(icon: "ball_01") {
                    scoreStore.actionPlay()
                }
                
                // Pause button
                MyActionBtn(icon: "action_pause") {
                    scoreStore.actionPause()
                }
                
                // Undo button
                MyActionBtn(icon: "action_cancel") {
                    scoreStore.actionEnd()
                }
                
                // QR code button
                MyActionBtn(icon: "action_change") {
                    scoreStore.actionChangeSwitch()
                }
            }
        }
        .padding(.trailing, 16.adapter)
    }
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

@available(iOS 17.0, *)
#Preview(traits: .landscapeLeft) {
    MatchSignatureScoringConfirmView()
        .background(Color.gray.opacity(0.1)) // Outline check
}
