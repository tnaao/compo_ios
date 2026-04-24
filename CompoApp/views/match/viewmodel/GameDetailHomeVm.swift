//
//  GameDetailHomeVm.swift
//  CompoApp
//
//  Created by Antigravity on 4/21/26.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

class GameDetailHomeVm: BaseListVm<WyBadmintonScheduleProgramModel> {
    @Published var matches: [WyBadmintonScheduleProgramModel] = []
    @Published var isLoadingMore = false
    
    // Summary count bindings if needed
    @Published var ongoingCount: Int64 = 0
    @Published var finishedCount: Int64 = 0

    override var list: [WyBadmintonScheduleProgramModel] {
        matches
    }
    
    var competitionNo: String = ""
    
    private var pageNo = 1
    private let pageSize = 200
    private var hasMoreData = true
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    func refresh(selectedTab: GameDetailTab) {
        pageNo = 1
        hasMoreData = true
        fetchData(isRefresh: true, selectedTab: selectedTab)
        fetchCounts()
    }
    
    func fetchCounts() {
        guard !competitionNo.isEmpty else { return }
        
        // Fetch ongoing total
        WyBadmintonRefereeAPI.getMatchScheduleList(competitionNo: competitionNo, listStatus: "1", pageNo: 1, pageSize: 1)
            .subscribe(onNext: { [weak self] response in
                if let total = response.data?.total {
                    self?.ongoingCount = total
                }
            }).disposed(by: disposeBag)
            
        // Fetch finished total
        WyBadmintonRefereeAPI.getMatchScheduleList(competitionNo: competitionNo, listStatus: "2", pageNo: 1, pageSize: 1)
            .subscribe(onNext: { [weak self] response in
                if let total = response.data?.total {
                    self?.finishedCount = total
                }
            }).disposed(by: disposeBag)
    }
    
    func loadMore(selectedTab: GameDetailTab) {
        guard hasMoreData && !isRefreshing && !isLoadingMore else { return }
        pageNo += 1
        fetchData(isRefresh: false, selectedTab: selectedTab)
    }
    
    private func fetchData(isRefresh: Bool, selectedTab: GameDetailTab) {
        // competitionNo should be set before fetching
        guard !competitionNo.isEmpty else { return }
        
        if isRefresh {
            isRefreshing = true
        } else {
            isLoadingMore = true
        }
        
        // Convert GameDetailTab to listStatus string
        let listStatus: String = {
            switch selectedTab {
            case .ongoing: return "1" // 1-进行中(含未开始+进行中)
            case .finished: return "2" // 2-已完成
            }
        }()
        
        WyBadmintonRefereeAPI.getMatchScheduleList(
            competitionNo: competitionNo,
            listStatus: listStatus,
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
                
                // Update total using response total if needed, or update counts
                // For example, if API doesn't return count per tab, we can at least count the list size
                if selectedTab == .ongoing {
                    self.ongoingCount = pagedData.total
                } else {
                    self.finishedCount = pagedData.total
                }
                
                self.hasMoreData = pagedData.list.count == self.pageSize
            } else {
                if !isRefresh { self.pageNo -= 1 }
                self.errorMessage = response.message
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.isRefreshing = false
            self.isLoadingMore = false
            if !isRefresh { self.pageNo -= 1 }
            self.errorMessage = error.localizedDescription
        })
        .disposed(by: disposeBag)
    }
}
