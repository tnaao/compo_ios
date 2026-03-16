//
//  UserInfo.swift
//  CompoApp
//
//  Created by Qoder on 3/16/26.
//

import Foundation

class UserInfo {
  static let shared = UserInfo()
  private init() {}

  var token: String? {
    get {
      return UserDefaults.standard.string(forKey: "user_token")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "user_token")
    }
  }

  var user: UserModel? {
    get {
      guard let data = UserDefaults.standard.data(forKey: "user_info") else { return nil }
      return try? JSONDecoder().decode(UserModel.self, from: data)
    }
    set {
      if let data = try? JSONEncoder().encode(newValue) {
        UserDefaults.standard.set(data, forKey: "user_info")
      }
    }
  }

  func clear() {
    token = nil
    user = nil
  }
}
