//
//  MatchResultPopupWrapper.swift
//  CompoApp
//
//  Created by Antigravity on 4/21/26.
//

import SwiftUI

/// Wrapper view that holds @State score values so we can read user-edited scores on confirm
struct MatchResultPopupWrapper: View {
    @ObservedObject var scoreStore: MatchScoringStore
    
    let t1p1Name: String
    let t1p1Avatar: String
    let t1p2Name: String
    let t1p2Avatar: String
    let t2p1Name: String
    let t2p1Avatar: String
    let t2p2Name: String
    let t2p2Avatar: String
    
    @State var s1s1: String
    @State var s1s2: String
    @State var s2s1: String
    @State var s2s2: String
    @State var s3s1: String
    @State var s3s2: String
    
    init(scoreStore: MatchScoringStore,
         t1p1Name: String, t1p1Avatar: String,
         t1p2Name: String, t1p2Avatar: String,
         t2p1Name: String, t2p1Avatar: String,
         t2p2Name: String, t2p2Avatar: String,
         initS1S1: String, initS1S2: String,
         initS2S1: String, initS2S2: String,
         initS3S1: String, initS3S2: String) {
        self.scoreStore = scoreStore
        self.t1p1Name = t1p1Name
        self.t1p1Avatar = t1p1Avatar
        self.t1p2Name = t1p2Name
        self.t1p2Avatar = t1p2Avatar
        self.t2p1Name = t2p1Name
        self.t2p1Avatar = t2p1Avatar
        self.t2p2Name = t2p2Name
        self.t2p2Avatar = t2p2Avatar
        _s1s1 = State(initialValue: initS1S1)
        _s1s2 = State(initialValue: initS1S2)
        _s2s1 = State(initialValue: initS2S1)
        _s2s2 = State(initialValue: initS2S2)
        _s3s1 = State(initialValue: initS3S1)
        _s3s2 = State(initialValue: initS3S2)
    }
    
    var body: some View {
        DoubleMatchResultEntryView(
            onCancel: {
                scoreStore.showMatchResult = false
            },
            onConfirm: {
                submitScores()
            },
            team1Player1Name: t1p1Name,
            team1Player1Avatar: t1p1Avatar,
            team1Player2Name: t1p2Name,
            team1Player2Avatar: t1p2Avatar,
            team2Player1Name: t2p1Name,
            team2Player1Avatar: t2p1Avatar,
            team2Player2Name: t2p2Name,
            team2Player2Avatar: t2p2Avatar,
            set1Score1: s1s1,
            set1Score2: s1s2,
            set2Score1: s2s1,
            set2Score2: s2s2,
            set3Score1: s3s1,
            set3Score2: s3s2
        )
    }
    
    private func submitScores() {
        let sets = scoreStore.scoreDetail?.scoreDetailList ?? []
        var scores: [(detailId: Int64, p1Score: Int32, p2Score: Int32)] = []
        
        if sets.count > 0 {
            scores.append((
                detailId: sets[0].detailId,
                p1Score: Int32(s1s1) ?? sets[0].player1Score ?? 0,
                p2Score: Int32(s1s2) ?? sets[0].player2Score ?? 0
            ))
        }
        if sets.count > 1 {
            scores.append((
                detailId: sets[1].detailId,
                p1Score: Int32(s2s1) ?? sets[1].player1Score ?? 0,
                p2Score: Int32(s2s2) ?? sets[1].player2Score ?? 0
            ))
        }
        if sets.count > 2 {
            scores.append((
                detailId: sets[2].detailId,
                p1Score: Int32(s3s1) ?? sets[2].player1Score ?? 0,
                p2Score: Int32(s3s2) ?? sets[2].player2Score ?? 0
            ))
        }
        
        if !scores.isEmpty {
            scoreStore.submitFinalResult(scores: scores)
        }
    }
}
