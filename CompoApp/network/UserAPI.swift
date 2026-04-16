//
//  UserAPI.swift
//  CompoApp
//
//  Created by Qoder on 3/16/26.
//

import RxSwift
import Alamofire

struct UserAPI {
    /// 短信登录
    /// - Parameters:
    ///   - mobile: 手机号
    ///   - code: 验证码
    /// - Returns: Observable<BaseModel<String>>
    static func smsLogin(mobile: String, code: String) -> Observable<BaseModel<String>> {
      let params = [
        "mobile": mobile,
        "code": code,
      ]
      return APIManager.shared.request(
        "/app-api/info/account/smsLogin",
        method: .post,
        params: params
      )
    }
    
    /// 获取用户信息
    static func getUserInfo() -> Observable<BaseModel<UserModel>> {
        APIManager.shared.request("/app-api/info/account/getInfo",method: .get)
    }
  /// 登录
  static func login(account: String, pwd: String) -> Observable<BaseModel<UserModel>> {
    let params = [
      "username": account,
      "password": pwd,
    ]
    return APIManager.shared.request(
      "/user/login",
      method: .post,
      params: params
    )
  }
}
