//
//  AppBadmintonCourtMessageRespVO.swift
//  CompoApp
//
//  Created by Antigravity on 4/27/26.
//

import Foundation

struct AppBadmintonCourtMessageRespVO: Codable, Identifiable {
    /// 消息ID
    let messageId: Int64
    /// 消息编号
    let messageNo: String?
    /// 赛事编号
    let competitionNo: String?
    /// 赛事名称
    let competitionName: String?
    /// 项目编号
    let eventNo: String?
    /// 项目名称
    let eventName: String?
    /// 场地编号
    let courtNo: String?
    /// 场地号
    let courtNumber: Int32?
    /// 消息类型
    let messageType: String?
    /// 消息内容
    let messageContent: String?
    /// 阅读状态：0-未读 1-已读
    let readStatus: Int32?
    /// 阅读时间
    let readTime: String?
    /// 创建时间
    let createTime: String?
    
    var id: Int64 { messageId }
}
