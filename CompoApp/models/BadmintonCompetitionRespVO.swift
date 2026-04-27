//
//  BadmintonCompetitionRespVO.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation
import SwiftUI

/// 管理后台 - 比赛 Response VO
struct BadmintonCompetitionRespVO: Codable, Identifiable, Sendable {
  // ... existing properties ...
  /// 比赛ID
  let competitionId: Int64
  /// 比赛编号
  let competitionNo: String
  /// 比赛名称
  let competitionName: String
  
  /// 系列赛编号（关联字段，使用编号而非ID）
  let seriesNo: String?
  /// 系列赛名称
  let seriesName: String?
  /// 运动类型：1-羽毛球
  let sportType: Int32?
  /// 比赛形式：1-单项赛
  let competitionFormat: Int32?
  
  /// 举办地址-省
  let province: String?
  /// 举办地址-市
  let city: String?
  /// 举办地址-区
  let district: String?
  /// 举办地址-详细地址
  let addressDetail: String?
  /// 省市区名称（如：北京市 北京市 朝阳区）
  let provinceCityDistrictName: String?
  
  /// 比赛开始时间
  let startTime: String?
  /// 比赛结束时间
  let endTime: String?
  /// 报名开始时间
  let registrationStart: String?
  /// 报名结束时间
  let registrationEnd: String?
  
  /// 报名状态：0-未开始 1-进行中 2-已结束 3-已取消
  let registrationStatus: Int32?
  /// 报名容量
  let registrationCapacity: Int32?
  /// 是否可超额：0-否 1-是
  let allowExceed: Int32?
  
  /// 报名链接
  let registrationLink: String?
  /// 报名二维码（图片URL）
  let registrationQrcode: String?
  
  /// 比赛状态：0-待发布 1-报名中 2-排赛中 3-比赛中 4-比赛结束
  let status: Int32?
  /// 发布状态：0-未发布 1-已发布
  let publishStatus: Int32?
  
  /// 联系方式
  let contactInfo: String?
  /// 举办单位
  let organizer: String?
  /// 封面海报（图片URL）
  let coverPoster: String?
  /// 轮播图（多个图片URL，JSON格式存储）
  let carouselImages: String?
  
  /// 赛事简介（富文本内容）
  let introductionFile: String?
  /// 报名须知（富文本内容）
  let registrationNoticeFile: String?
  /// 赛事规程（富文本内容）
  let competitionRulesFile: String?
  /// 免责声明（富文本内容）
  let disclaimerFile: String?
  
  /// 比赛场地
  let venue: String?
  /// 比赛描述
  let description: String?
  
  /// 创建者
  let createBy: String?
  /// 创建时间
  let createTime: String?
  /// 更新者
  let updateBy: String?
  /// 备注
  let remark: String?
  
  /// 参赛人数
  let participantCount: Int64?
  /// 比赛日期展示，例如：12.21（周日）08:00 - 17:00
  let competitionDate: String?
  /// 报名人头像列表（最多 5 个）
  let participantAvatars: [String]?
  
  // Identifiable implementation
  var id: Int64 { competitionId }
}

extension BadmintonCompetitionRespVO {
  var uiTitle: String { competitionName }
  var uiDateTime: String { competitionDate ?? "待定" }
  var uiLocation: String {
    let parts = [province, city, district, addressDetail]
      .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty }
    
    var uniqueParts: [String] = []
    for part in parts {
      if !uniqueParts.contains(part) {
        uniqueParts.append(part)
      }
    }
    
    if !uniqueParts.isEmpty {
      return uniqueParts.joined()
    }
    
    return venue ?? "待定"
  }
  var uiStatusTitle: String {
    switch status {
    case 3: return "进行中"
    case 4: return "已完成"
    default: return "报名中"
    }
  }
  var uiStatusColor: Color {
    switch status {
    case 3: return Color(red: 0.2, green: 0.8, blue: 0.4)
    case 4: return Color(red: 0.6, green: 0.6, blue: 0.6)
    default: return Color(red: 1.0, green: 0.4, blue: 0.2)
    }
  }
  var uiImageName: String { coverPoster ?? "" }
}
