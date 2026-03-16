//
//  BaseModel.swift
//  CompoApp
//
//  Created by Qoder on 3/16/26.
//

import Foundation

struct BaseModel<T: Codable>: Codable {
  let code: Int?
  let msg: String?
  let data: T?
}

extension BaseModel {
    var isValid: Bool {
        return code == 200
    }
}
