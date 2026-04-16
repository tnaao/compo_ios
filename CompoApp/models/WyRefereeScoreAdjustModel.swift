//
//  WyRefereeScoreAdjustModel.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 对本局加减分响应数据
struct WyRefereeScoreAdjustModel: Codable, Identifiable, Sendable {
  /// 详细比分编号 detail_no
  let detailNo: String
  /// 比赛编号 match_no
  let matchNo: String
  /// 计分规则封顶分数（单局单方得分上限）
  let cappedScore: Int32
  /// 计分规则每局获胜分（如 21 分制）
  let scorePerRound: Int32
  /// 选手1配对组编号（对阵 pair1_no，对应本局 player1）
  let pair1No: String
  /// 选手2配对组编号（对阵 pair2_no，对应本局 player2）
  let pair2No: String
  /// 局状态 round_status：0-未开始 1-进行中 2-已结束
  let roundStatus: Int32
  /// 本局选手1得分
  let player1Score: Int32
  /// 本局选手2得分
  let player2Score: Int32
  /// 选手1大局比分（已赢局数）
  let pair1Score: Int32
  /// 选手2大局比分（已赢局数）
  let pair2Score: Int32
  /// 是否已有一方按计分规则达到获胜分（可结束本局）
  let reachedWinningScore: Bool
  /// 提示文案，例如已有一方达到获胜分时提示结束本局
  let hintMessage: String?
  /// 是否轮空：0-否 1-是
  let isBye: Int32
  
  // Use detailNo as ID for Identifiable
  var id: String { detailNo }
}
