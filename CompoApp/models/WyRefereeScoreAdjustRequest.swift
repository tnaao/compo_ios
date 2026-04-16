//
//  WyRefereeScoreAdjustRequest.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 对本局加减分请求参数
struct WyRefereeScoreAdjustRequest: Codable, Sendable {
  /// 详细比分编号 detail_no
  let detailNo: String
  /// 比赛编号 match_no
  let matchNo: String
  /// 变更配对组编号（须为本场 pair1_no 或 pair2_no）
  let pairNo: String
  /// 分数变更类型：1-加分 2-减分
  let changeType: Int32
  /// 变更分数（正整数；加分时增加、减分时减少）
  let scoreDelta: Int32
  
  // Custom naming mapping if needed, but the TS field names match the server's expected camelCase/snake_case mapping in this project's APIManager
  enum CodingKeys: String, CodingKey {
    case detailNo
    case matchNo
    case pairNo
    case changeType
    case scoreDelta
  }
}
