//
//  WyRefereeMatchScoreDetailModel.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 根据比赛编号查询详细比分响应数据
struct WyRefereeMatchScoreDetailModel: Codable, Sendable {
  /// 比赛编号 match_no
  let matchNo: String?
  /// 比赛编码 match_code
  let matchCode: String?
  /// 项目编号 event_no
  let eventNo: String?
  /// 项目名称
  let eventName: String?
  
  /// 配对组1选手数组
  let pair1List: [PlayerItemModel]?
  /// 配对组2选手数组
  let pair2List: [PlayerItemModel]?
  
  /// 每局详细比分列表
  let scoreDetailList: [ScoreDetailItemModel]?
}

/// 每局详细比分列表项
struct ScoreDetailItemModel: Codable, Sendable, Identifiable {
  /// 详细比分ID detail_id
  let detailId: Int64
  /// 详细比分编号 detail_no
  let detailNo: String?
  /// 局数
  let roundNumber: Int32?
  /// 选手1本局得分
  let player1Score: Int32?
  /// 选手2本局得分
  let player2Score: Int32?
  /// 状态：0-未开始 1-进行中 2-已结束
  let roundStatus: Int32?
  /// 本局获胜者：1-选手1 2-选手2
  let roundWinner: Int32?
  
  /// Identifiable id
  var id: Int64 { detailId }
}
