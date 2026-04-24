//
//  WyRefereeMatchScoreDetailModel.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 根据比赛编号查询详细比分响应数据
struct WyRefereeMatchScoreDetailModel: Codable, Sendable,Equatable {
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
  
  /// 配对组1检录状态：0-未检录 1-已检录 2-弃权
  let pair1CheckinStatus: Int32?
  /// 配对组2检录状态：0-未检录 1-已检录 2-弃权
  let pair2CheckinStatus: Int32?
  
  /// 比赛状态：0-未开始 1-进行中 2-已结束 3-弃权
  let matchStatus: Int32?
  
  /// 配对组1大比分（局分）
  let pair1Score: Int32?
  /// 配对组2大比分（局分）
  let pair2Score: Int32?
  
  /// 裁判签名地址
  let refereeSignature: String?
  /// 胜方签名地址
  let winnerSignature: String?
  
  /// 每局详细比分列表
  let scoreDetailList: [ScoreDetailItemModel]?
}

extension WyRefereeMatchScoreDetailModel {
    func getSetScore(by index: Int) -> ScoreDetailItemModel? {
        guard let list = scoreDetailList else { return nil }
        return list[(index-1).defMaxValue(list.count-1)]
    }
}

/// 每局详细比分列表项
struct ScoreDetailItemModel: Codable, Sendable, Identifiable,Equatable {
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
  /// 发球方：1-选手1 2-选手2
  let firstServer: Int32?
  /// 场地交换：0-未交换 1-已交换
  let courtSwapped: Int32?
  
  /// Identifiable id
  var id: Int64 { detailId }
}
