//
//  APIManager.swift
//  CompoApp
//
//  Created by Qoder on 3/16/26.
//

import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift
import SVProgressHUD

class APIManager {
  static let shared = APIManager()
  private init() {}

  let session: Session = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = APIConfig.timeout
    return Session(configuration: config)
  }()

  let authInterceptor: AuthInterceptor = AuthInterceptor()
}

// MARK: - 通用请求方法
extension APIManager {
  /// 通用请求，返回 Observable<BaseModel<T>>
  func request<T: Codable>(
    _ url: String,
    method: HTTPMethod = .get,
    params: [String: Any]? = nil,
    headers: HTTPHeaders? = nil,
    showHUD: Bool = true
  ) -> Observable<BaseModel<T>> {

    // 显示加载
    if showHUD { SVProgressHUD.show() }

    let fullUrl = APIConfig.baseUrl + url

    var finalHeaders = headers
    // 这里统一加 Token
    if let token = UserInfo.shared.token {
      finalHeaders = HTTPHeaders([
        "Authorization": "Bearer \(token)"
      ])
    }

    return RxAlamofire.requestData(
      method,
      fullUrl,
      parameters: params,
      headers: finalHeaders,
      interceptor: authInterceptor,
    )
    .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    .map { $1 }
    .decode(type: BaseModel<T>.self, decoder: JSONDecoder())
    .observe(on: MainScheduler.instance)
    .do(
      onNext: { [weak self] res in
        SVProgressHUD.dismiss()
        // 后端约定 code 成功：比如 200
        if !res.isValid {
          SVProgressHUD.showInfo(withStatus: res.msg)
        }
        // Token 过期 401
        if res.code == 401 {
          self?.handleTokenExpired()
        }
      },
      onError: { err in
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "网络异常")
      })
  }
}

// MARK: - Token 过期处理
extension APIManager {
  private func handleTokenExpired() {
    UserInfo.shared.token = nil
    // 跳登录
    // AppManager.shared.toLogin()
  }
}
