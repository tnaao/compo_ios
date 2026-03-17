//
//  MatchModel.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//

import SwiftUI

struct MatchModel:Codable, Identifiable {
    var id: String { title }
    var title: String
    var dateTime: String
    var location: String
    var status: MatchStatus = .ongoing
    var imageName: String
}

enum MatchStatus:String, Codable {
    case ongoing
    case completed

    var key: String {
        switch self {
        case .ongoing:
            return "ongoingKey"
        case .completed:
            return "completedKey"
        }
    }
}

extension MatchStatus {
    
    var title: String {
        switch self {
        case .ongoing:
            return "进行中"
        case .completed:
            return "已完成"
        }
    }
    
    var backgroundColor: Color {
      switch self {
      case .ongoing:
        return Color(red: 0.2, green: 0.8, blue: 0.4)
      case .completed:
        return Color(red: 0.6, green: 0.6, blue: 0.6)
      }
    }
}
