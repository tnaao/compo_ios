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
  case home
  case detail(id: String)
  case gamedetailItem(id: String)
  case matchScoring(id: String)
  case gamedetailHome
  case matchSignature
  case settings
  case login
  case HeaderPreviewView
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

typealias ApRoute = SimpleRouter<Destination, Sheet>

struct AppRouterKey: EnvironmentKey {
  // 必须提供一个默认值
  static let defaultValue: ApRoute = AppRouter.shared.appRouter
}

struct SafeEdgesKey: EnvironmentKey {
  // 必须提供一个默认值
  static let defaultValue: EdgeInsets = ScreenInfo.shared.safeAreaInsets
}

struct IsLandscapeKey: EnvironmentKey {
  // 必须提供一个默认值
    static let defaultValue: Bool = ScreenInfo.shared.orientation.isLandscape
}

extension EnvironmentValues {
  var appRouter: ApRoute {
    get { self[AppRouterKey.self] }
    set { self[AppRouterKey.self] = newValue }
  }
  var safeAreaInsets: EdgeInsets {
    get { self[SafeEdgesKey.self] }
    set { self[SafeEdgesKey.self] = newValue }
  }
  var isLandscape: Bool {
    get { self[IsLandscapeKey.self] }
    set { self[IsLandscapeKey.self] = newValue }
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

class AppRouter : ObservableObject{
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
          case .HeaderPreviewView:
          HeaderPreviewView().hideNavigationBar()
      case .launch,.home:
          ContentView().hideNavigationBar()
      case .matchSignature:
          MatchSignatureView().hideNavigationBar()
          case .login:
          LoginView().hideNavigationBar()
          default:
          BlankView()
          }
        
        
    }
}
