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
import CleanJSON

class APIManager {
  static let shared = APIManager()
  private init() {}

  let session: Session = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = APIConfig.timeout

    // Configure proxy (Debug only)
    #if DEBUG
    if APIConfig.enableDebugProxy {
      config.connectionProxyDictionary = [
        kCFNetworkProxiesHTTPEnable: true,
        kCFNetworkProxiesHTTPProxy: APIConfig.debugProxyHost,
        kCFNetworkProxiesHTTPPort: APIConfig.debugProxyPort,
      ]
    }
    #endif

    return Session(configuration: config)
  }()

  let authInterceptor: AuthInterceptor = AuthInterceptor()
}

enum APIRequestEncoding {
  case urlEncoded
  case json

  var contentType: String {
    switch self {
    case .urlEncoded:
      return "application/x-www-form-urlencoded"
    case .json:
      return "application/json"
    }
  }

  func parameterEncoding(for method: Alamofire.HTTPMethod) -> ParameterEncoding {
    switch self {
    case .json:
      return JSONEncoding.default
    case .urlEncoded:
      switch method {
      case .get, .delete:
        return URLEncoding.default
      default:
        return URLEncoding.httpBody
      }
    }
  }
}

// MARK: - 通用请求方法
extension APIManager {
  /// 通用请求，返回 Observable<BaseModel<T>>
  func request<T: Codable>(
    _ url: String,
    method: Alamofire.HTTPMethod = .get,
    params: [String: Any]? = nil,
    headers: HTTPHeaders? = nil,
    requestEncoding: APIRequestEncoding? = nil,
    showHUD: Bool = false,
    isShowLogicInfo:Bool = true
  ) -> Observable<BaseModel<T>> {

    // 显示加载
    if showHUD { SVProgressHUD.show() }

    let fullUrl = APIConfig.baseUrl + url

    let resolvedEncoding = requestEncoding ?? {
      switch method {
      case .post, .put:
        return .json
      default:
        return .urlEncoded
      }
    }()

    var finalHeaders = headers ?? HTTPHeaders()
    if finalHeaders["Content-Type"] == nil {
      if requestEncoding == nil {
        finalHeaders.add(name: "Content-Type", value: "application/json")
      } else {
        finalHeaders.add(name: "Content-Type", value: resolvedEncoding.contentType)
      }
    }

    let encoding: ParameterEncoding
    if requestEncoding == nil {
      encoding = switch method {
      case .post:
        JSONEncoding.default
      case .put:
        JSONEncoding.default
      default:
        URLEncoding.default
      }
    } else {
      encoding = resolvedEncoding.parameterEncoding(for: method)
    }

    print("[APIManager] Request -> \(method.rawValue) \(fullUrl)")
    if let params,
      let requestData = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted]),
      let requestString = String(data: requestData, encoding: .utf8)
    {
      print("[APIManager] Request Data -> \(requestString)")
    } else if let params {
      print("[APIManager] Request Data -> \(params)")
    } else {
      print("[APIManager] Request Data -> nil")
    }

    return session.rx.responseData(
      method,
      fullUrl,
      parameters: params,
      encoding: encoding,
      headers: finalHeaders,
      interceptor: authInterceptor
    )
    .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    .map { responseData -> Data in
      if let jsonString = String(data: responseData.1, encoding: .utf8) {
        print("[APIManager] Response Data -> \(jsonString)")
      }
      return responseData.1
    }
    .decode(type: BaseModel<T>.self, decoder: CleanJSONDecoder())
    .catch { error -> Observable<BaseModel<T>> in
      // 捕获并详细记录解码错误
      print("[APIManager] Decoding error: \(error.localizedDescription)")
      if let decodingError = error as? DecodingError {
        switch decodingError {
        case .typeMismatch(let type, let context):
          print(
            "[APIManager] Type mismatch: expected \(type), path: \(context.codingPath), debug: \(context.debugDescription)"
          )
        case .valueNotFound(let type, let context):
          print(
            "[APIManager] Value not found: \(type), path: \(context.codingPath), debug: \(context.debugDescription)"
          )
        case .keyNotFound(let key, let context):
          print(
            "[APIManager] Key not found: \(key), path: \(context.codingPath), debug: \(context.debugDescription)"
          )
        case .dataCorrupted(let context):
          print(
            "[APIManager] Data corrupted: path: \(context.codingPath), debug: \(context.debugDescription)"
          )
        @unknown default:
          print("[APIManager] Unknown decoding error: \(decodingError)")
        }
      }
      return Observable.error(error)
    }
    .observe(on: MainScheduler.instance)
    .do(
      onNext: { [weak self] res in
        if showHUD {
          SVProgressHUD.dismiss()
        }
        // 后端约定 code 成功：比如 200
        if !res.isValid {
            if isShowLogicInfo {
                ScreenInfo.showInfo(res.msg)
            }
        }
        // Token 过期
        if res.code == 10086 {
          self?.handleTokenExpired()
        }
      },
      onError: { err in
        print("[APIManager] Request failed with error: \(err.localizedDescription)")

        if showHUD {
          SVProgressHUD.dismiss()
        }
        ScreenInfo.showError("网络异常")
      })
  }
}

// MARK: - Token 过期处理
extension APIManager {
  private func handleTokenExpired() {
    UserInfo.shared.token = nil
    // 跳登录
    AppRouter.shared.goLogin()
  }
}
