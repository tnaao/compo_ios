//
//  ScreenInfo.swift
//  zswing
//
//  Created by GH w on 3/17/26.
//

internal import Combine
import SVProgressHUD
import SwiftUI
import UIKit

class ScreenInfo: ObservableObject {

  @Published
  var safeAreaInsets: EdgeInsets = EdgeInsets.init()

  @Published
  var orientation: UIDeviceOrientation = UIDevice.current.orientation

  private var cancellables = Set<AnyCancellable>()

  static var shared: ScreenInfo = .init()
  var ratio = 1.5
  let baseW = Double(683)
  var baseH:Double{
     Double(683 / ratio)
  }

  var width: CGFloat {
      false ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
  }
  var height: CGFloat {
      false ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
  }
    
    func calculateRatio(){
        let width = ScreenInfo.shared.width
        let height = ScreenInfo.shared.height
        let ratio = width * 1.0 / height
        ScreenInfo.shared.ratio = ratio
    }

  var isLandscape: Bool {
    orientation.isLandscape
  }

  var isPortrait: Bool {
      orientation.isPortrait
  }
  init() {
    // Listen for orientation changes
    NotificationCenter.default
      .publisher(for: UIDevice.orientationDidChangeNotification)
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.orientation = UIDevice.current.orientation
        calculateRatio()
      }
      .store(in: &cancellables)
  }
}

// MARK: - Global Error Display Extension
extension ScreenInfo {
  /// 显示错误信息（使用SVProgressHUD）
  /// - Parameters:
  ///   - message: 错误信息
  ///   - duration: 显示时长（秒），默认2秒
  static func showError(_ message: String?, duration: TimeInterval = 2.0) {
    guard let message = message, !message.isEmpty else { return }
    SVProgressHUD.showError(withStatus: message)
    SVProgressHUD.dismiss(withDelay: duration)
    print("Error: \(message)")
  }

  /// 显示信息（使用SVProgressHUD）
  /// - Parameters:
  ///   - message: 信息内容
  ///   - duration: 显示时长（秒），默认2秒
  static func showInfo(_ message: String?, duration: TimeInterval = 2.0) {
    guard let message = message, !message.isEmpty else { return }
    SVProgressHUD.showInfo(withStatus: message)
    SVProgressHUD.dismiss(withDelay: duration)
  }

  /// 显示信息（使用SVProgressHUD）
  /// - Parameters:
  ///   - message: 信息内容
  ///   - duration: 显示时长（秒），默认2秒
  static func showSuccess(_ message: String?, duration: TimeInterval = 2.0) {
    guard let message = message, !message.isEmpty else { return }
    SVProgressHUD.showSuccess(withStatus: message)
    SVProgressHUD.dismiss(withDelay: duration)
  }

  /// 显示加载中
  static func showLoading(_ status: String? = nil) {
    SVProgressHUD.setDefaultMaskType(.clear)
    if let status = status {
      SVProgressHUD.show(withStatus: status)
    } else {
      SVProgressHUD.show()
    }
  }

  /// 显示进度
  static func showProgress(_ progress: Float, status: String? = nil) {
    SVProgressHUD.setDefaultMaskType(.clear)
    SVProgressHUD.showProgress(progress, status: status)
  }

  /// 隐藏所有提示
  static func dismissHUD() {
    SVProgressHUD.dismiss()
  }
}
