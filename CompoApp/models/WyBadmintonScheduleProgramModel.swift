//
//  WyBadmintonScheduleProgramModel.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 裁判端查询赛事列表数据模型
struct WyBadmintonScheduleProgramModel: Codable, Sendable, Identifiable {
  /// 比赛编号
  let competitionNo: String?
  /// 比赛名称
  let competitionName: String?
  /// 项目编号
  let eventNo: String?
  /// 项目名称
  let eventName: String?
  /// 项目编码
  let eventCode: String?
  /// 比赛编号
  let matchNo: String?
  /// 比赛编码
  let matchCode: String?
  /// 比赛类型
  let matchType: String?
  /// 轮次类型
  let roundType: String?
  
  /// 配对组1
  let pair1List: [PlayerItemModel]?
  /// 配对组2名称
  let pair2List: [PlayerItemModel]?
  
  /// 是否轮空
  let isBye: Bool?
  
  /// 配对组1检录状态：0-未检录 1-已检录 2-弃权
  let pair1CheckinStatus: Int32?
  /// 配对组2检录状态：0-未检录 1-已检录 2-弃权
  let pair2CheckinStatus: Int32?
  
  /// 配对组1是否弃权：0-否 1-是
  let pair1Forfeit: Int32?
  /// 配对组2是否弃权：0-否 1-是
  let pair2Forfeit: Int32?
  
  /// 比赛状态：0-未开始 1-进行中 2-已结束 3-弃权
  let matchStatus: Int32?
  
  /// 配对组1大比分（局分）
  let pair1Score: Int32?
  /// 配对组2大比分（局分）
  let pair2Score: Int32?
  
  /// 场地信息
  let courtInfo: CourtInfo?
  /// 场次信息
  let matchSession: MatchSession?
  
  /// Identifiable id (using matchNo if available, else UUID)
  var id: String { matchNo ?? UUID().uuidString }
}

/// App - 参赛选手项
struct PlayerItemModel: Codable, Sendable, Identifiable {
  /// 选手ID
  let playerId: Int64
  /// 选手编号
  let playerNo: String
  /// 配对组编号
  let pairNo: String
  /// 选手姓名
  let playerName: String
  /// 头像地址
  let avatar: String?
  /// 俱乐部名称
  let clubName: String?
  
  /// Identifiable id
  var id: Int64 { playerId }
}

/// 场地信息
struct CourtInfo: Codable, Sendable {
  /// 场地编号
  let courtNo: String?
  /// 场地名称
  let courtName: String?
  /// 场地编号（数字）
  let courtNumber: Int32?
}

/// 场次信息
struct MatchSession: Codable, Sendable {
  /// 场次编号
  let sessionNo: String?
  /// 场次序号
  let sessionOrder: Int32?
  /// 日期
  let date: String?
  /// 时间
  let time: String?
}
