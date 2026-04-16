//
//  UserModel.swift
//  CompoApp
//
//  Created by Qoder on 3/16/26.
//

import Foundation

struct UserModel: Codable {
  let id: Int64?
  let mobile: String?
  let nickname: String?
  let avatar: String?
  let sex: Int?
  let idCard: String?
  let accountLevel: Int?
  let vipLevelType: Int?
  let singlePurchaseDuration: Double?
  let vipStartTime: String?
  let vipEndTime: String?
  let traineeNum: Int?
  let recentlyTraineeName: String?
  let bindStatus: Int?
  let bindTime: String?
  let accountStatus: Int?
  let bookingVenue: Int?
  let createTime: String?
  /// 身高（cm）
  let heightValue: Int?
  /// 体重（kg）
  let weightValue: Int?
  /// 年龄
  let ageValue: Int?

  var phone: String? {
    mobile
  }

  enum CodingKeys: String, CodingKey {
    case id
    case mobile
    case phone
    case nickname
    case avatar
    case sex
    case idCard
    case accountLevel
    case vipLevelType
    case singlePurchaseDuration
    case vipStartTime
    case vipEndTime
    case traineeNum
    case recentlyTraineeName
    case bindStatus
    case bindTime
    case accountStatus
    case bookingVenue
    case createTime
    case heightValue
    case weightValue
    case ageValue
  }

  init(
    id: Int64? = nil,
    mobile: String? = nil,
    nickname: String? = nil,
    avatar: String? = nil,
    sex: Int? = nil,
    idCard: String? = nil,
    accountLevel: Int? = nil,
    vipLevelType: Int? = nil,
    singlePurchaseDuration: Double? = nil,
    vipStartTime: String? = nil,
    vipEndTime: String? = nil,
    traineeNum: Int? = nil,
    recentlyTraineeName: String? = nil,
    bindStatus: Int? = nil,
    bindTime: String? = nil,
    accountStatus: Int? = nil,
    bookingVenue: Int? = nil,
    createTime: String? = nil,
    heightValue: Int? = nil,
    weightValue: Int? = nil,
    ageValue: Int? = nil
  ) {
    self.id = id
    self.mobile = mobile
    self.nickname = nickname
    self.avatar = avatar
    self.sex = sex
    self.idCard = idCard
    self.accountLevel = accountLevel
    self.vipLevelType = vipLevelType
    self.singlePurchaseDuration = singlePurchaseDuration
    self.vipStartTime = vipStartTime
    self.vipEndTime = vipEndTime
    self.traineeNum = traineeNum
    self.recentlyTraineeName = recentlyTraineeName
    self.bindStatus = bindStatus
    self.bindTime = bindTime
    self.accountStatus = accountStatus
    self.bookingVenue = bookingVenue
    self.createTime = createTime
    self.heightValue = heightValue
    self.weightValue = weightValue
    self.ageValue = ageValue
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(Int64.self, forKey: .id)
    mobile =
      try container.decodeIfPresent(String.self, forKey: .mobile)
      ?? (try container.decodeIfPresent(String.self, forKey: .phone))
    nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
    avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
    sex = try container.decodeIfPresent(Int.self, forKey: .sex)
    idCard = try container.decodeIfPresent(String.self, forKey: .idCard)
    accountLevel = try container.decodeIfPresent(Int.self, forKey: .accountLevel)
    vipLevelType = try container.decodeIfPresent(Int.self, forKey: .vipLevelType)
    singlePurchaseDuration = try container.decodeIfPresent(
      Double.self,
      forKey: .singlePurchaseDuration
    )
    vipStartTime = try container.decodeIfPresent(String.self, forKey: .vipStartTime)
    vipEndTime = try container.decodeIfPresent(String.self, forKey: .vipEndTime)
    traineeNum = try container.decodeIfPresent(Int.self, forKey: .traineeNum)
    recentlyTraineeName = try container.decodeIfPresent(
      String.self,
      forKey: .recentlyTraineeName
    )
    bindStatus = try container.decodeIfPresent(Int.self, forKey: .bindStatus)
    bindTime = try container.decodeIfPresent(String.self, forKey: .bindTime)
    accountStatus = try container.decodeIfPresent(Int.self, forKey: .accountStatus)
    bookingVenue = try container.decodeIfPresent(Int.self, forKey: .bookingVenue)
    createTime = try container.decodeIfPresent(String.self, forKey: .createTime)
    heightValue = try container.decodeIfPresent(Int.self, forKey: .heightValue)
    weightValue = try container.decodeIfPresent(Int.self, forKey: .weightValue)
    ageValue = try container.decodeIfPresent(Int.self, forKey: .ageValue)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(id, forKey: .id)
    try container.encodeIfPresent(mobile, forKey: .mobile)
    try container.encodeIfPresent(nickname, forKey: .nickname)
    try container.encodeIfPresent(avatar, forKey: .avatar)
    try container.encodeIfPresent(sex, forKey: .sex)
    try container.encodeIfPresent(idCard, forKey: .idCard)
    try container.encodeIfPresent(accountLevel, forKey: .accountLevel)
    try container.encodeIfPresent(vipLevelType, forKey: .vipLevelType)
    try container.encodeIfPresent(singlePurchaseDuration, forKey: .singlePurchaseDuration)
    try container.encodeIfPresent(vipStartTime, forKey: .vipStartTime)
    try container.encodeIfPresent(vipEndTime, forKey: .vipEndTime)
    try container.encodeIfPresent(traineeNum, forKey: .traineeNum)
    try container.encodeIfPresent(recentlyTraineeName, forKey: .recentlyTraineeName)
    try container.encodeIfPresent(bindStatus, forKey: .bindStatus)
    try container.encodeIfPresent(bindTime, forKey: .bindTime)
    try container.encodeIfPresent(accountStatus, forKey: .accountStatus)
    try container.encodeIfPresent(bookingVenue, forKey: .bookingVenue)
    try container.encodeIfPresent(createTime, forKey: .createTime)
    try container.encodeIfPresent(heightValue, forKey: .heightValue)
    try container.encodeIfPresent(weightValue, forKey: .weightValue)
    try container.encodeIfPresent(ageValue, forKey: .ageValue)
  }
}

struct AppTopStatisticsModel: Codable {
  let myTraining: Int64?
  let myMatch: Int64?
  let myActivity: Int64?
  let club: Int64?
}

class OpData: Codable {

}
