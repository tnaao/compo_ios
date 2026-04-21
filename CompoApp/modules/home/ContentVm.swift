//
//  ContentVm.swift
//  CompoApp
//
//  Created by Antigravity on 4/17/26.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

class ContentVm: BaseListVm<BadmintonCompetitionRespVO> {
    @Published var matches: [BadmintonCompetitionRespVO] = []
    @Published var isLoadingMore = false

    override var list: [BadmintonCompetitionRespVO] {
        matches
    }
    
    private var pageNo = 1
    private let pageSize = 20
    private var hasMoreData = true
    private let disposeBag = DisposeBag()
    
    override init() {}
    
    func refresh(selectedTab: AppTab) {
        pageNo = 1
        hasMoreData = true
        fetchData(isRefresh: true, selectedTab: selectedTab)
    }
    
    func loadMore(selectedTab: AppTab) {
        guard hasMoreData && !isRefreshing && !isLoadingMore else { return }
        pageNo += 1
        fetchData(isRefresh: false, selectedTab: selectedTab)
    }
    
    private func fetchData(isRefresh: Bool, selectedTab: AppTab) {
        if isRefresh {
            isRefreshing = true
        } else {
            isLoadingMore = true
        }
        
        let status: String? = {
            switch selectedTab {
            case .all: return nil
            case .ongoing: return "1"
            case .finished: return "2"
            }
        }()
        
        print("[ContentVm] Fetching data for tab: \(selectedTab.rawValue), status: \(status ?? "nil"), page: \(pageNo)")
        
        WyBadmintonRefereeAPI.getRefereeCompetitionPage(
            competitionName: nil,
            status: status,
            pageNo: pageNo,
            pageSize: pageSize
        )
        .subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.isRefreshing = false
            self.isLoadingMore = false
            
            if response.isValid, let pagedData = response.data {
                let newItems = pagedData.list
                if isRefresh {
                    self.matches = newItems
                } else {
                    self.matches.append(contentsOf: newItems)
                }
                self.hasMoreData = pagedData.list.count == self.pageSize
                print("[ContentVm] Fetched \(newItems.count) items. Total: \(self.matches.count), HasMore: \(self.hasMoreData)")
            } else {
                print("[ContentVm] Response invalid or data nil")
                if !isRefresh { self.pageNo -= 1 }
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.isRefreshing = false
            self.isLoadingMore = false
            if !isRefresh { self.pageNo -= 1 }
            print("[ContentVm] Error: \(error.localizedDescription)")
        })
        .disposed(by: disposeBag)
    }
}
