//
//  WyRefereeMatchForfeitRequest.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 弃权比分请求参数
struct WyRefereeMatchForfeitRequest: Codable, Sendable {
  /// 比赛编号列表（不能为空）
  let matchNos: [String]
  /// 弃权方：1-选手1弃权 2-选手2弃权
  let forfeitSide: Int32
  /// 备注
  let remark: String?
  
  enum CodingKeys: String, CodingKey {
    case matchNos
    case forfeitSide
    case remark
  }
}
