//
//  WyRefereeSignatureRequest.swift
//  zswing
//
//  Created by Qoder on 4/16/26.
//

import Foundation

/// 裁判签名请求参数
struct WyRefereeSignatureRequest: Codable, Sendable {
  /// 比赛编号 match_no
  let matchNo: String
  /// 签名图片（路径或 base64）
  let signatureImage: String
  
  enum CodingKeys: String, CodingKey {
    case matchNo
    case signatureImage
  }
}
