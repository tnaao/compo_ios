//
//  BaseVm.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//

import Foundation
import Combine

class BaseListVm<T:Identifiable>: ObservableObject {
    
    @Published var didInitData: Bool = false
    
    var list: [T] {
        []
    }

    /// 是否正在加载
    @Published var isLoading: Bool = false
    /// 是否正在刷新
    @Published var isRefreshing: Bool = false
    /// 错误信息
    @Published var errorMessage: String? = nil
    
    /// 加载状态
    var loadingState: XdLoadingState {
      if isRefreshing {
          return .normal
      }
      if isLoading && list.isEmpty {
          return .loading
      }
      if errorMessage != nil && list.isEmpty {
          return .failure
      }
      if !isLoading && list.isEmpty {
          return .noData
      }
      return .normal
    }
    
    deinit {}
}
