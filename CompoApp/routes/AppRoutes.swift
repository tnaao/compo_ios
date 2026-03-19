//
//  AppRoutes.swift
//  CompoApp
//
//  Created by GH w on 3/15/26.
//

import AppRouter
import SwiftUI
internal import Combine

enum Destination: DestinationType {
  case launch
  case detail(id: String)
  case gamedetailItem(id: String)
  case matchScoring(id: String)
  case gamedetailHome
  case settings
  case login
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
  case login
  case settings

  var id: Int { hashValue }
}

enum AppTab: String, TabType, CaseIterable, Hashable,Codable {
  case all
  case ongoing
  case finished

  var id: String { rawValue }

  var icon: String {
    switch self {
    case .all: return "Tab1"
    case .ongoing: return "Tab2"
    case .finished: return "Tab3"
    }
  }

  var title: String {
    switch self {
    case .all: return "全部"
    case .ongoing: return "进行中"
    case .finished: return "已完成"
    }
  }
}

@Observable class AppRouter {
  var appRouter = SimpleRouter<Destination, Sheet>()
  var tabRouter = Router<AppTab, Destination, Sheet>(initialTab: .all)
  var selectedTab: AppTab = .all
  var isLoggedIn: Bool = false

  static let shared = AppRouter()
    
    @ViewBuilder
    func sheetView(for sheet: Sheet) -> some View {
      switch sheet {
      case .settings:
        VStack {
          Text("Settings Sheet")
        }
      case .login:
        LoginView()
      }
    }
    
    @ViewBuilder
    func destinationView(for destination: Destination) -> some View {
      switch destination {
          case .gamedetailHome:
          GameDetailHomeView().hideNavigationBar()
      case .matchScoring(id: let id):
          MatchScoringView().hideNavigationBar()
          case .profile(let userId):
            VStack {
              Text("Profile \(userId)")
            }
          case .login:
          LoginView().hideNavigationBar()
      default:
          BlankView()
          }
        
        
    }
}
