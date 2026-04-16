//
//  WyRefereeScoreAdjustDetailRequest.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 查询局比分详情或结束比赛请求参数
struct WyRefereeScoreAdjustDetailRequest: Codable, Sendable {
  /// 比赛编号 match_no
  let matchNo: String
  /// 详细比分编号 detail_no
  let detailNo: String
  /// 首局发球方：1-选手1 2-选手2
  let firstServer: Int32?
  /// 是否已交换场地：0-否 1-是
  let courtSwapped: Int32?
  
  enum CodingKeys: String, CodingKey {
    case matchNo
    case detailNo
    case firstServer
    case courtSwapped
  }
}
