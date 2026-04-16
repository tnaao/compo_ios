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
    return code == 200 || code == 0
  }
}

/// 分页结果包装
struct PagedWrapper<T: Codable>: Codable {
  /// 总量
  let total: Int64
  /// 数据
  let list: [T]
}
