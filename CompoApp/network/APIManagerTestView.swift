//
//  APIManagerTestView.swift
//  zswing
//
//  Created by Qoder on 3/21/26.
//

import Alamofire
import Combine
import RxCocoa
import RxSwift
import SwiftUI

struct APIManagerTestView: View {
  @StateObject private var viewModel = APIManagerTestViewModel()

  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        // URL 路径输入区域
        VStack(alignment: .leading, spacing: 8) {
          Text("API 路径")
            .font(.headline)
            .foregroundColor(.secondary)

          TextField("输入API路径 (如: /api/user/info)", text: $viewModel.apiPath)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        .padding(.horizontal)

        // 请求方法选择
        Picker("请求方法", selection: $viewModel.httpMethod) {
          ForEach(HTTPMethodType.allCases) { method in
            Text(method.rawValue).tag(method)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)

        // 测试按钮
        Button(action: {
          viewModel.testAPI()
        }) {
          HStack {
            Image(systemName: "bolt.fill")
            Text(viewModel.isTesting ? "请求中..." : "发送请求")
          }
          .frame(maxWidth: .infinity)
          .padding()
          .background(viewModel.isTesting ? Color.gray : Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
        }
        .noClickEffect()
        .disabled(viewModel.isTesting)
        .padding(.horizontal)

        // 结果显示区域
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            if let result = viewModel.testResult {
              // 状态指示
              HStack {
                Circle()
                  .fill(result.isSuccess ? Color.green : Color.red)
                  .frame(width: 12, height: 12)
                Text(result.isSuccess ? "请求成功" : "请求失败")
                  .font(.headline)
                  .foregroundColor(result.isSuccess ? .green : .red)
              }

              Divider()

              // 响应信息
              if let code = result.code {
                InfoRowView(title: "业务码", value: "\(code)")
              }

              if let message = result.message {
                InfoRowView(title: "消息", value: message, isError: !result.isSuccess)
              }

              if let responseTime = result.responseTime {
                InfoRowView(title: "响应时间", value: String(format: "%.2f ms", responseTime))
              }

              if let errorDetail = result.errorDetail {
                InfoRowView(title: "错误详情", value: errorDetail, isError: true)
              }

              Divider()

              // 响应内容
              if let responseData = result.responseData {
                VStack(alignment: .leading, spacing: 8) {
                  Text("响应内容")
                    .font(.headline)

                  Text(responseData)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
              }
            } else {
              Text("点击按钮测试 APIManager 请求")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 50)
            }
          }
          .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal)

        Spacer()
      }
      .padding(.top)
      .navigationTitle("APIManager 测试")
    }
  }
}

// 信息行组件
struct InfoRowView: View {
  let title: String
  let value: String
  var isError: Bool = false

  var body: some View {
    HStack(alignment: .top) {
      Text(title)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .frame(width: 80, alignment: .leading)

      Text(value)
        .font(.body)
        .foregroundColor(isError ? .red : .primary)
        .lineLimit(nil)

      Spacer()
    }
  }
}

// HTTP 方法枚举
enum HTTPMethodType: String, CaseIterable, Identifiable {
  case GET = "GET"
  case POST = "POST"
  case PUT = "PUT"
  case DELETE = "DELETE"

  var id: String { self.rawValue }

  var alamofireMethod: Alamofire.HTTPMethod {
    switch self {
    case .GET: return .get
    case .POST: return .post
    case .PUT: return .put
    case .DELETE: return .delete
    }
  }
}

// 测试结果模型
struct APIManagerTestResult {
  let isSuccess: Bool
  let code: Int?
  let message: String?
  let responseTime: Double?
  let responseData: String?
  let errorDetail: String?
}

// ViewModel
class APIManagerTestViewModel: ObservableObject {
  @Published
  var apiPath: String = "/app-api/info/account/getInfo"
  @Published var httpMethod: HTTPMethodType = .GET
  @Published var isTesting: Bool = false
  @Published var testResult: APIManagerTestResult?

  private let disposeBag = DisposeBag()

  func testAPI() {
    isTesting = true
    testResult = nil

    let startTime = Date()

    // 使用空的 Codable 结构来接收任意响应
    struct EmptyData: Codable {}

    APIManager.shared.request<EmptyData>(
      apiPath,
      method: httpMethod.alamofireMethod,
      params: nil,
      headers: nil,
      showHUD: false
    )
    .subscribe(
      onNext: { [weak self] (baseModel: BaseModel<EmptyData>) in
        let responseTime = Date().timeIntervalSince(startTime) * 1000

        let responseData = try? JSONEncoder().encode(baseModel)
        let responseString = responseData.flatMap { String(data: $0, encoding: .utf8) }

        self?.testResult = APIManagerTestResult(
          isSuccess: baseModel.isValid,
          code: baseModel.code,
          message: baseModel.msg,
          responseTime: responseTime,
          responseData: responseString,
          errorDetail: nil
        )
        self?.isTesting = false
      },
      onError: { [weak self] error in
        let responseTime = Date().timeIntervalSince(startTime) * 1000

        self?.testResult = APIManagerTestResult(
          isSuccess: false,
          code: nil,
          message: nil,
          responseTime: responseTime,
          responseData: nil,
          errorDetail: error.localizedDescription
        )
        self?.isTesting = false
      }
    )
    .disposed(by: disposeBag)
  }
}

struct APIManagerTestView_Previews: PreviewProvider {
  static var previews: some View {
    APIManagerTestView()
  }
}
