//
//  WyRefereeBatchUpdateScoreRequest.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 批量修改比赛详细比分表请求参数
struct WyRefereeBatchUpdateScoreRequest: Codable, Sendable {
  /// 详细比分列表
  struct ScoreDetail: Codable, Sendable {
    /// 详细比分ID
    let detailId: Int64
    /// 选手1本局得分
    let player1Score: Int32?
    /// 选手2本局得分
    let player2Score: Int32?
  }
  
  /// 详细比分列表（不能为空）
  let scoreDetails: [ScoreDetail]
}
