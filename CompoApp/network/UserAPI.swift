//
//  UserAPI.swift
//  CompoApp
//
//  Created by Qoder on 3/16/26.
//

import RxSwift
import Alamofire

struct UserAPI {
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

  /// 获取用户信息
  static func getUserInfo() -> Observable<BaseModel<UserModel>> {
    APIManager.shared.request("/user/info")
  }
}
