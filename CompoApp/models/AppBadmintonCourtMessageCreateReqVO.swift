//
//  AppBadmintonCourtMessageCreateReqVO.swift
//  CompoApp
//
//  Created by Antigravity on 4/27/26.
//

import Foundation

struct AppBadmintonCourtMessageCreateReqVO: Codable {
    /// 比赛编号 match_no
    let matchNo: String
    /// 消息类型
    let messageType: String
    /// 消息内容
    let messageContent: String
    
    init(matchNo: String, messageType: String, messageContent: String) {
        self.matchNo = matchNo
        self.messageType = messageType
        self.messageContent = messageContent
    }
}
