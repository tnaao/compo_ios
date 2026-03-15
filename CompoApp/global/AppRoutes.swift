//
//  AppRoutes.swift
//  CompoApp
//
//  Created by GH w on 3/15/26.
//

import AppRouter
import SwiftUI

enum Destination: DestinationType {
  case detail(id: String)
  case settings
  case profile(userId: String)

  static func from(path: String, fullPath: [String], parameters: [String: String]) -> Destination? {
    switch path {
    case "detail":
      let id = parameters["id"] ?? "unknown"
      return .detail(id: id)
    case "settings":
      return .settings
    case "profile":
      let userId = parameters["userId"] ?? "unknown"
      return .profile(userId: userId)
    default:
      return nil
    }
  }
}

enum Sheet: SheetType {
  case compose
  case settings

  var id: Int { hashValue }
}

enum AppTab: String, TabType, CaseIterable, Hashable {
  case wakuku
  case personality
  case diary
  case profile

  var id: String { rawValue }

  var icon: String {
    switch self {
    case .wakuku: return "Tab1"
    case .personality: return "Tab2"
    case .diary: return "Tab3"
    case .profile: return "Tab4"
    }
  }

  var title: String {
    switch self {
    case .wakuku: return "wakuku"
    case .personality: return "性格分析"
    case .diary: return "心事日历"
    case .profile: return "我的"
    }
  }
}

@Observable class AppRouter {
  var appRouter = Router<AppTab, Destination, Sheet>(initialTab: .wakuku)
  var selectedTab: AppTab = .wakuku

  static let shared = AppRouter()
}
