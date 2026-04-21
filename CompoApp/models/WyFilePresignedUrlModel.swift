//
//  WyFilePresignedUrlModel.swift
//  zswing
//
//  文件预签名地址响应数据模型
//

import Foundation

/// 文件预签名地址响应数据
struct WyFilePresignedUrlModel: Codable, Identifiable {
  /// 配置编号
  let configId: Int64
  /// 文件上传 URL
  let uploadUrl: String
  /// 文件访问 URL
  let url: String
  /// 文件路径
  let path: String

  /// Identifiable id
  var id: Int64 { configId }
}
