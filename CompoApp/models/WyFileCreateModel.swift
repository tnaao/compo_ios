//
//  WyFileCreateModel.swift
//  zswing
//
//  文件创建请求数据模型
//

import Foundation

/// 文件创建请求数据
struct WyFileCreateRequest: Codable {
  /// 文件配置编号
  let configId: Int64
  /// 文件路径
  let path: String
  /// 原文件名
  let name: String
  /// 文件 URL
  let url: String
  /// 文件 MIME 类型
  let type: String?
  /// 文件大小
  let size: Int32
}
