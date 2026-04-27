//
//  WyBadmintonRefereeAPI.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Alamofire
import RxSwift

struct WyBadmintonRefereeAPI {
  /// 分页查询当前登录裁判关联的赛事
  /// - Parameters:
  ///   - competitionName: 赛事名称（模糊）
  ///   - status: 赛事状态筛选：1-进行中(未结束) 2-已结束；不传则不过滤
  ///   - pageNo: 页码，从 1 开始
  ///   - pageSize: 每页条数，最大值为 200
  /// - Returns: Observable<BaseModel<PagedWrapper<BadmintonCompetitionRespVO>>>
  static func getRefereeCompetitionPage(
    competitionName: String? = nil,
    status: String? = nil,
    pageNo: Int = 1,
    pageSize: Int = 10
  ) -> Observable<BaseModel<PagedWrapper<BadmintonCompetitionRespVO>>> {
    var params: [String: Any] = [
      "pageNo": pageNo,
      "pageSize": pageSize
    ]
    if let competitionName = competitionName {
      params["competitionName"] = competitionName
    }
    if let status = status {
      params["status"] = status
    }
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/match/page",
      method: .get,
      params: params
    )
  }

  /// 对本局加减分（须已开赛且本局进行中；受封顶分与每局获胜分约束）
  /// - Parameter request: 加减分请求参数
  /// - Returns: Observable<BaseModel<WyRefereeScoreAdjustModel>>
  static func adjustScore(
    request: WyRefereeScoreAdjustRequest
  ) -> Observable<BaseModel<WyRefereeScoreAdjustModel>> {
    let params: [String: Any] = [
      "detailNo": request.detailNo,
      "matchNo": request.matchNo,
      "pairNo": request.pairNo,
      "changeType": request.changeType,
      "scoreDelta": request.scoreDelta
    ]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/adjust-score",
      method: .post,
      params: params
    )
  }

  /// 根据详细比分编号与比赛编号查询局比分详情
  /// - Parameter request: 查询详情请求参数
  /// - Returns: Observable<BaseModel<WyRefereeScoreAdjustModel>>
  static func getAdjustScoreDetail(
    request: WyRefereeScoreAdjustDetailRequest
  ) -> Observable<BaseModel<WyRefereeScoreAdjustModel>> {
    var params: [String: Any] = [
      "matchNo": request.matchNo,
      "detailNo": request.detailNo
    ]
    if let firstServer = request.firstServer { params["firstServer"] = firstServer }
    if let courtSwapped = request.courtSwapped { params["courtSwapped"] = courtSwapped }
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/adjust-score-detail",
      method: .post,
      params: params
    )
  }

  /// 批量修改比赛详细比分表
  /// - Parameter request: 批量修改请求参数
  /// - Returns: Observable<BaseModel<Bool>>
  static func batchUpdateScoreDetails(
    request: WyRefereeBatchUpdateScoreRequest
  ) -> Observable<BaseModel<Bool>> {
    let details = request.scoreDetails.map { detail -> [String: Any] in
      var dict: [String: Any] = ["detailId": detail.detailId]
      if let p1 = detail.player1Score { dict["player1Score"] = p1 }
      if let p2 = detail.player2Score { dict["player2Score"] = p2 }
      return dict
    }
    let params: [String: Any] = ["scoreDetails": details]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/batch-update-score-details",
      method: .post,
      params: params
    )
  }

  /// 结束比赛
  /// - Parameter request: 结束比赛请求参数
  /// - Returns: Observable<BaseModel<Bool>>
  static func endMatch(
    request: WyRefereeScoreAdjustDetailRequest
  ) -> Observable<BaseModel<Bool>> {
    var params: [String: Any] = [
      "matchNo": request.matchNo,
      "detailNo": request.detailNo
    ]
    if let firstServer = request.firstServer { params["firstServer"] = firstServer }
    if let courtSwapped = request.courtSwapped { params["courtSwapped"] = courtSwapped }
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/end-match",
      method: .post,
      params: params
    )
  }

  /// 弃权比分接口
  /// - Parameter request: 弃权请求参数
  /// - Returns: Observable<BaseModel<Bool>>
  static func forfeitScoreDetails(
    request: WyRefereeMatchForfeitRequest
  ) -> Observable<BaseModel<Bool>> {
    let params: [String: Any] = [
      "matchNos": request.matchNos,
      "forfeitSide": request.forfeitSide,
      "remark": request.remark ?? ""
    ]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/forfeit-score-details",
      method: .post,
      params: params
    )
  }

  /// 裁判端查询赛事列表
  /// - Parameters:
  ///   - competitionNo: 赛事编号 competition_no
  ///   - listStatus: 列表状态：1-进行中(含未开始+进行中) 2-已完成
  ///   - pageNo: 页码，从 1 开始
  ///   - pageSize: 每页条数，最大值为 200
  /// - Returns: Observable<BaseModel<PagedWrapper<WyBadmintonScheduleProgramModel>>>
  static func getMatchScheduleList(
    competitionNo: String,
    listStatus: String,
    pageNo: Int = 1,
    pageSize: Int = 10
  ) -> Observable<BaseModel<PagedWrapper<WyBadmintonScheduleProgramModel>>> {
    let params: [String: Any] = [
      "competitionNo": competitionNo,
      "listStatus": listStatus,
      "pageNo": pageNo,
      "pageSize": pageSize
    ]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/match-list",
      method: .get,
      params: params
    )
  }

  /// 裁判签名（比赛编号 + 签名图片）
  /// - Parameter request: 签名请求参数
  /// - Returns: Observable<BaseModel<Bool>>
  static func refereeSign(
    request: WyRefereeSignatureRequest
  ) -> Observable<BaseModel<Bool>> {
    let params: [String: Any] = [
      "matchNo": request.matchNo,
      "signatureImage": request.signatureImage
    ]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/referee-sign",
      method: .post,
      params: params
    )
  }

  /// 根据比赛编号查询详细比分
  /// - Parameter matchNo: 比赛编号
  /// - Returns: Observable<BaseModel<WyRefereeMatchScoreDetailModel>>
  static func getMatchScoreDetail(
    matchNo: String
  ) -> Observable<BaseModel<WyRefereeMatchScoreDetailModel>> {
    let params: [String: Any] = ["matchNo": matchNo]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/score-detail",
      method: .get,
      params: params
    )
  }

  /// 开始比赛（返回当前比赛状态：1-进行中；轮空场直接返回2-已结束）
  /// - Parameter request: 开始比赛请求参数
  /// - Returns: Observable<BaseModel<Int32>>
  static func startMatch(
    request: WyRefereeScoreAdjustDetailRequest
  ) -> Observable<BaseModel<Int32>> {
    var params: [String: Any] = [
      "matchNo": request.matchNo,
      "detailNo": request.detailNo
    ]
    if let firstServer = request.firstServer { params["firstServer"] = firstServer }
    if let courtSwapped = request.courtSwapped { params["courtSwapped"] = courtSwapped }
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/start-match",
      method: .post,
      params: params
    )
  }

  /// 跳过局次（如三局两胜已决出胜方时，允许将第三局记为0:0并结束）
  /// - Parameter request: 请求参数
  /// - Returns: Observable<BaseModel<Bool>>
  static func skipScoreDetail(
    request: WyRefereeScoreAdjustDetailRequest
  ) -> Observable<BaseModel<Bool>> {
    var params: [String: Any] = [
      "matchNo": request.matchNo,
      "detailNo": request.detailNo
    ]
    if let firstServer = request.firstServer { params["firstServer"] = firstServer }
    if let courtSwapped = request.courtSwapped { params["courtSwapped"] = courtSwapped }
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/skip-score-detail",
      method: .post,
      params: params
    )
  }

  /// 根据比赛编号查询是否已热身
  /// - Parameter matchNo: 比赛编号
  /// - Returns: Observable<BaseModel<Bool>>
  static func getWarmupStatus(
    matchNo: String
  ) -> Observable<BaseModel<Bool>> {
    let params: [String: Any] = ["matchNo": matchNo]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/warmup-status",
      method: .get,
      params: params
    )
  }

  /// 根据比赛编号修改热身时间
  /// - Parameter request: 热身时间修改请求参数
  /// - Returns: Observable<BaseModel<Bool>>
  static func updateWarmupTime(
    request: WyRefereeWarmupUpdateRequest
  ) -> Observable<BaseModel<Bool>> {
    let params: [String: Any] = [
      "matchNo": request.matchNo,
      "warmupDuration": request.warmupDuration
    ]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/update-warmup-time",
      method: .post,
      params: params
    )
  }

  /// 胜方签名（比赛编号 + 签名图片）
  /// - Parameter request: 签名请求参数
  /// - Returns: Observable<BaseModel<Bool>>
  static func winnerSign(
    request: WyRefereeSignatureRequest
  ) -> Observable<BaseModel<Bool>> {
    let params: [String: Any] = [
      "matchNo": request.matchNo,
      "signatureImage": request.signatureImage
    ]
    
    return APIManager.shared.request(
      "/app-api/badminton/referee/schedule/winner-sign",
      method: .post,
      params: params
    )
  }

  /// 创建比赛消息（入参：matchNo、消息类型、消息内容）
  /// - Parameter request: 创建消息请求参数
  /// - Returns: Observable<BaseModel<Int64>>
  static func createMatchMessage(
    request: AppBadmintonCourtMessageCreateReqVO
  ) -> Observable<BaseModel<Int64>> {
    let params: [String: Any] = [
      "matchNo": request.matchNo,
      "messageType": request.messageType,
      "messageContent": request.messageContent
    ]
    
    return APIManager.shared.request(
      "/app-api/badminton/app/court-message/create",
      method: .post,
      params: params
    )
  }

  /// 根据消息ID查询详情（查询后自动已读）
  /// - Parameter messageId: 消息ID
  /// - Returns: Observable<BaseModel<AppBadmintonCourtMessageRespVO>>
  static func getMessageDetailById(
    messageId: Int64
  ) -> Observable<BaseModel<AppBadmintonCourtMessageRespVO>> {
    let params: [String: Any] = ["messageId": messageId]
    
    return APIManager.shared.request(
      "/app-api/badminton/app/court-message/get",
      method: .get,
      params: params
    )
  }

  /// 根据赛事编号分页查询场地消息列表（按创建时间倒序）
  /// - Parameters:
  ///   - competitionNo: 赛事编号
  ///   - readStatus: 阅读状态：0-未读 1-已读
  ///   - pageNo: 页码
  ///   - pageSize: 每页条数
  /// - Returns: Observable<BaseModel<PagedWrapper<AppBadmintonCourtMessageRespVO>>>
  static func getMatchMessagePage(
    competitionNo: String? = nil,
    readStatus: String? = nil,
    pageNo: Int = 1,
    pageSize: Int = 20
  ) -> Observable<BaseModel<PagedWrapper<AppBadmintonCourtMessageRespVO>>> {
    var params: [String: Any] = [
      "pageNo": pageNo,
      "pageSize": pageSize
    ]
    if let competitionNo = competitionNo { params["competitionNo"] = competitionNo }
    if let readStatus = readStatus { params["readStatus"] = readStatus }
    
    return APIManager.shared.request(
      "/app-api/badminton/app/court-message/page",
      method: .get,
      params: params
    )
  }
}
