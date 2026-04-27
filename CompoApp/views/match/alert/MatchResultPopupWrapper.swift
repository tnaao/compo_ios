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
    
    // We'll let DoubleMatchResultEntryView handle its own state now
    // and just provide the confirmation logic
    
    var body: some View {
        DoubleMatchResultEntryView(
            onCancel: {
                scoreStore.showMatchResult = false
            },
            onConfirm: { scores in
                submitScores(scores: scores)
            },
            team1Player1Name: t1p1Name,
            team1Player1Avatar: t1p1Avatar,
            team1Player2Name: t1p2Name,
            team1Player2Avatar: t1p2Avatar,
            team2Player1Name: t2p1Name,
            team2Player1Avatar: t2p1Avatar,
            team2Player2Name: t2p2Name,
            team2Player2Avatar: t2p2Avatar
        )
    }
    
    private func submitScores(scores: [String]) {
        let sets = scoreStore.scoreDetail?.scoreDetailList ?? []
        var resultScores: [(detailId: Int64, p1Score: Int32, p2Score: Int32)] = []
        
        for i in 0..<sets.count {
            let scoreIdx = i * 2
            if scoreIdx + 1 < scores.count {
                resultScores.append((
                    detailId: sets[i].detailId,
                    p1Score: Int32(scores[scoreIdx]) ?? sets[i].player1Score ?? 0,
                    p2Score: Int32(scores[scoreIdx+1]) ?? sets[i].player2Score ?? 0
                ))
            }
        }
        
        let scoresFiltered = resultScores.filter { $0.p1Score + $0.p2Score > 0 }
        if !scoresFiltered.isEmpty {
            scoreStore.submitFinalResult(scores: scoresFiltered)
        }
    }
}
