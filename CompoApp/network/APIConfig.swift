//
//  APIConfig.swift
//  CompoApp
//
//  Created by Qoder on 3/16/26.
//

import Foundation

struct APIConfig {
  static let baseUrl = "http://124.223.109.229:48080"
  static let timeout: TimeInterval = 20
  // Keep disabled by default; when this host is unreachable all debug traffic fails before reaching the backend.
  static let enableDebugProxy = true
//  static let debugProxyHost = "192.168.0.203"
  static let debugProxyHost = "192.168.124.14"
  static let debugProxyPort = 9090
  static let noOrderDetailApi = true
  static let shouldAutoLogin = false
}
