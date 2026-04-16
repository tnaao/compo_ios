//
//  WyRefereeWarmupUpdateRequest.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 根据比赛编号修改热身时间请求参数
struct WyRefereeWarmupUpdateRequest: Codable, Sendable {
  /// 比赛编号 match_no
  let matchNo: String
  /// 热身时长（分钟）
  let warmupDuration: Int32
  
  enum CodingKeys: String, CodingKey {
    case matchNo
    case warmupDuration
  }
}
