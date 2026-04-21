//
//  UploadAPI.swift
//  zswing
//
//  文件上传API
//

import Alamofire
import RxSwift

struct UploadAPI {
  /// 获取文件预签名地址（上传）
  /// - Parameters:
  ///   - name: 文件名称
  ///   - directory: 文件目录（可选）
  /// - Returns: Observable<BaseModel<WyFilePresignedUrlModel>>
  static func getPresignedUrl(
    name: String,
    directory: String? = nil
  ) -> Observable<BaseModel<WyFilePresignedUrlModel>> {
    var params: [String: Any] = [
      "name": name
    ]
    if let directory = directory {
      params["directory"] = directory
    }
    return APIManager.shared.request(
      "/app-api/infra/file/presigned-url",
      method: .get,
      params: params
    )
  }

  /// 上传文件
  /// - Parameters:
  ///   - imageData: 文件数据
  ///   - fileName: 文件名
  ///   - mimeType: MIME类型，默认image/jpeg
  ///   - directory: 文件目录（可选）
  /// - Returns: Observable<BaseModel<String>> 返回文件URL
  static func uploadImage(
    imageData: Data,
    fileName: String = "image.jpg",
    mimeType: String = "image/jpeg",
    directory: String? = nil
  ) -> Observable<BaseModel<String>> {
    var fullUrl = APIConfig.baseUrl + "/app-api/infra/file/upload"

    // Add directory query parameter if provided
    if let directory = directory,
      let encodedDirectory = directory.addingPercentEncoding(
        withAllowedCharacters: .urlQueryAllowed)
    {
      fullUrl += "?directory=\(encodedDirectory)"
    }

    print("[UploadAPI] Request -> POST \(fullUrl)")
    print("[UploadAPI] Headers -> zswtoken: Bearer \(UserInfo.shared.token ?? "")")
    print("[UploadAPI] File -> name: \(fileName), mimeType: \(mimeType), size: \(imageData.count)")

    return Observable.create { observer in
      AF.upload(
        multipartFormData: { multipartFormData in
          multipartFormData.append(
            imageData,
            withName: "file",
            fileName: fileName,
            mimeType: mimeType
          )
        },
        to: fullUrl,
        headers: [
          "zswtoken": "Bearer \(UserInfo.shared.token ?? "")"
        ]
      )
      .validate()
      .responseData { response in
        switch response.result {
        case .success(let data):
          if let jsonString = String(data: data, encoding: .utf8) {
            print("[UploadAPI] Response JSON: \(jsonString)")
          }
          do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(BaseModel<String>.self, from: data)
            observer.onNext(result)
            observer.onCompleted()
          } catch {
            print("[UploadAPI] Decode error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
              print("[UploadAPI] Response: \(jsonString)")
            }
            observer.onError(error)
          }
        case .failure(let error):
          print("[UploadAPI] Upload error: \(error)")
          observer.onError(error)
        }
      }

      return Disposables.create()
    }
    .observe(on: MainScheduler.instance)
  }

  /// 创建文件记录
  /// - Parameter request: 文件创建请求数据
  /// - Returns: Observable<BaseModel<Int64>>
  static func createFile(request: WyFileCreateRequest) -> Observable<BaseModel<Int64>> {
    let params: [String: Any] = [
      "configId": request.configId,
      "path": request.path,
      "name": request.name,
      "url": request.url,
      "size": request.size,
      "type": request.type ?? "",
    ]
    return APIManager.shared.request(
      "/app-api/infra/file/create",
      method: .post,
      params: params
    )
  }

  /// 全局文件上传（使用预签名地址）
  /// - Parameters:
  ///   - fileData: 文件数据
  ///   - fileName: 文件名
  ///   - mimeType: MIME类型，默认image/jpeg
  ///   - directory: 文件目录（可选）
  /// - Returns: Observable<BaseModel<String>> 返回文件访问URL
  static func uploadFileWithPresignedUrl(
    fileData: Data,
    fileName: String = "image.jpg",
    mimeType: String = "image/jpeg",
    directory: String? = nil
  ) -> Observable<BaseModel<String>> {
    return getPresignedUrl(name: fileName, directory: directory)
      .flatMap { response -> Observable<BaseModel<WyFilePresignedUrlModel>> in
        guard response.isValid, let presignedData = response.data, let uploadUrl = URL(string: presignedData.uploadUrl) else {
          let errorMsg = response.msg ?? "获取预签名地址失败"
          return Observable.just(BaseModel(code: response.code, msg: errorMsg, data: nil))
        }

        return Observable.create { observer in
          var request = URLRequest(url: uploadUrl)
          request.httpMethod = "PUT"
          request.setValue(mimeType, forHTTPHeaderField: "Content-Type")

          AF.upload(fileData, with: request)
            .validate()
            .response { uploadResponse in
              switch uploadResponse.result {
              case .success:
                observer.onNext(response)
                observer.onCompleted()
              case .failure(let error):
                observer.onError(error)
              }
            }
          return Disposables.create()
        }
      }
      .flatMap { response -> Observable<BaseModel<String>> in
        guard response.isValid, let presignedData = response.data else {
          return Observable.just(BaseModel(code: response.code, msg: response.msg, data: nil))
        }

        let request = WyFileCreateRequest(
          configId: presignedData.configId,
          path: presignedData.path,
          name: fileName,
          url: presignedData.url,
          type: mimeType,
          size: Int32(fileData.count)
        )

        return createFile(request: request)
          .map { createResponse -> BaseModel<String> in
            if createResponse.isValid {
              return BaseModel(code: createResponse.code, msg: createResponse.msg, data: presignedData.url)
            } else {
              return BaseModel(code: createResponse.code, msg: createResponse.msg, data: nil)
            }
          }
      }
      .observe(on: MainScheduler.instance)
  }
}
