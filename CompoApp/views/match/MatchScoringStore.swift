//
//  RefereeMatchScoringVm.swift
//  CompoApp
//
//  Created by Antigravity on 4/21/26.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

@MainActor
enum MatchRunningState: String {
    case notStarted = "未开始"
    case warmingUp = "热身"
    case playing = "比赛中"
    case finished = "结束"
}

@MainActor
class MatchScoringStore: ObservableObject {

    static let shared = MatchScoringStore()

    @Published var scoreDetail: WyRefereeMatchScoreDetailModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isActionSuccess: Bool = false
    
    @Published var currentEvent:BadmintonCompetitionRespVO? = nil
    @Published var currentMatch:WyBadmintonScheduleProgramModel? = nil
    
    @Published var isWarmedUp: Bool = true {
        didSet { syncRunningState() }
    }
    
    @Published var isWarmingUpNow: Bool = false {
        didSet { syncRunningState() }
    }
    
    private var countdownTimer: AnyCancellable?
    private var remainingWarmupSeconds: Int = 0
    
    private var matchTimer: AnyCancellable?
    private var matchElapsedSeconds: Int = 0
    @Published var isPaused: Bool = false
    
    @Published var timerString: String = "00:00:00"
    
    @Published var currentSetNumber: Int = 1
    @Published var runningState: MatchRunningState = .notStarted
    
    @Published var firstServer: Int32? = nil
    @Published var courtSwapped: Int32? = 0
    
    @Published var showWarmupPopup: Bool = false
    @Published var showMatchResult: Bool = false
    @Published var showConfirmBegin: Bool = false
    @Published var showConfirmEnd: Bool = false
    
    private var pendingServeTeam: Int32? = nil
    
    var gameStateText:String {
        if !isWarmedUp {
            return ""
        }
        switch runningState {
        case .warmingUp: return ""
        default: return "第\(currentSetNumber)局"
        }
    }

    private let disposeBag = DisposeBag()
    
    /// 获取详细比分
    func fetchMatchScoreDetail(matchNo: String) {
        isLoading = true
        WyBadmintonRefereeAPI.getMatchScoreDetail(matchNo: matchNo)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid {
                    self.scoreDetail = response.data
                    self.syncRunningState()
                } else {
                    self.errorMessage = response.msg ?? "获取比分详情失败"
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func syncRunningState() {
        if let lastRound = scoreDetail?.scoreDetailList?.last {
            let setNumber = Int(lastRound.roundNumber ?? 1)
            self.currentSetNumber = setNumber
            
            // Automatically detect court swap based on badminton rules
            var shouldBeSwapped = (setNumber % 2 == 0)
            if setNumber >= 3 {
                let p1s = lastRound.player1Score ?? 0
                let p2s = lastRound.player2Score ?? 0
                if p1s >= 11 || p2s >= 11 {
                    shouldBeSwapped.toggle()
                }
            }
            self.courtSwapped = shouldBeSwapped ? 1 : 0
        }
        
        let mStatus = currentMatch?.matchStatus ?? 0
        if mStatus == 2 || mStatus == 3 {
            self.runningState = .finished
        } else if mStatus == 1 {
            self.runningState = .playing
        } else {
            if isWarmingUpNow {
                self.runningState = .warmingUp
            } else {
                self.runningState = .notStarted
            }
        }
    }
    
    /// 开始比赛
    func startMatch(matchNo: String, detailNo: String, firstServer: Int32? = nil, courtSwapped: Int32? = nil) {
        isLoading = true
        let request = WyRefereeScoreAdjustDetailRequest(
            matchNo: matchNo,
            detailNo: detailNo,
            firstServer: firstServer,
            courtSwapped: courtSwapped
        )
        WyBadmintonRefereeAPI.startMatch(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid {
                    self.isActionSuccess = true
                    self.startMatchTimer()
                    // Refresh data after starting
                    self.fetchMatchScoreDetail(matchNo: matchNo)
                } else {
                    self.errorMessage = response.message ?? "开始比赛失败"
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    /// 调整比分(加减分)
    /// - Parameters:
    ///   - changeType: 1-加分 2-减分
    func adjustScore(matchNo: String, detailNo: String, pairNo: String, changeType: Int32, scoreDelta: Int32 = 1) {
        isLoading = true
        let request = WyRefereeScoreAdjustRequest(
            detailNo: detailNo,
            matchNo: matchNo,
            pairNo: pairNo,
            changeType: changeType,
            scoreDelta: scoreDelta
        )
        WyBadmintonRefereeAPI.adjustScore(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid {
                    self.isActionSuccess = true
                    // Update score detail locally or fetch again
                    self.fetchMatchScoreDetail(matchNo: matchNo)
                } else {
                    self.errorMessage = response.message ?? "调整比分失败"
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    /// 结束比赛
    func endMatch(matchNo: String, detailNo: String, firstServer: Int32? = nil, courtSwapped: Int32? = nil) {
        isLoading = true
        let request = WyRefereeScoreAdjustDetailRequest(
            matchNo: matchNo,
            detailNo: detailNo,
            firstServer: firstServer,
            courtSwapped: courtSwapped
        )
        WyBadmintonRefereeAPI.endMatch(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid {
                    self.isActionSuccess = true
                    self.fetchMatchScoreDetail(matchNo: matchNo)
                    self.showMatchResult = true
                } else {
                    self.errorMessage = response.message ?? "结束比赛失败"
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func actionPlay() -> Void {
        self.showWarmupPopup = true
    }
    
    func actionStartServe(team: Int32) {
        self.firstServer = team
        guard runningState == .notStarted || runningState == .warmingUp else { return }
        self.pendingServeTeam = team
        self.showConfirmBegin = true
    }
    
    func confirmStartMatch() {
        guard let team = pendingServeTeam,
              let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.scoreDetailList?.last?.detailNo else { return }
        self.showConfirmBegin = false
        startMatch(matchNo: matchNo, detailNo: detailNo, firstServer: team, courtSwapped: courtSwapped)
    }
    
    func cancelStartMatch() {
        self.showConfirmBegin = false
        self.pendingServeTeam = nil
    }
    
    func actionPause() -> Void {
        guard runningState == .playing else { return }
        isPaused.toggle()
        if isPaused {
            matchTimer?.cancel()
            matchTimer = nil
        } else {
            resumeMatchTimer()
        }
    }
    
    func actionEnd() -> Void {
        guard runningState == .playing else { return }
        self.showConfirmEnd = true
    }
    
    func confirmEndMatch() {
        self.showConfirmEnd = false
        stopMatchTimer()
        isPaused = false
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.scoreDetailList?.last?.detailNo else { return }
        endMatch(matchNo: matchNo, detailNo: detailNo, firstServer: firstServer, courtSwapped: courtSwapped)
    }
    
    func cancelEndMatch() {
        self.showConfirmEnd = false
    }
    
    /// 提交最终比赛结果（批量更新各局比分）
    func submitFinalResult(scores: [(detailId: Int64, p1Score: Int32, p2Score: Int32)]) {
        isLoading = true
        let details = scores.map {
            WyRefereeBatchUpdateScoreRequest.ScoreDetail(
                detailId: $0.detailId,
                player1Score: $0.p1Score,
                player2Score: $0.p2Score
            )
        }
        let request = WyRefereeBatchUpdateScoreRequest(scoreDetails: details)
        WyBadmintonRefereeAPI.batchUpdateScoreDetails(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid {
                    self.isActionSuccess = true
                    self.showMatchResult = false
                    if let matchNo = self.currentMatch?.matchNo {
                        self.fetchMatchScoreDetail(matchNo: matchNo)
                        //返回上一页
                        AppRouter.shared.appRouter.popNavigation()
                    }
                } else {
                    self.errorMessage = response.message ?? "提交比赛结果失败"
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func actionChangeSwitch() -> Void {
        let current = courtSwapped ?? 0
        courtSwapped = (current == 0) ? 1 : 0
    }
    
    func scoreMinusLeft() -> Void {
        let isSwapped = (courtSwapped == 1)
        let pairList = isSwapped ? currentMatch?.pair2List : currentMatch?.pair1List
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.scoreDetailList?.last?.detailNo,
              let pairNo = pairList?.first?.pairNo else { return }
        adjustScore(matchNo: matchNo, detailNo: detailNo, pairNo: pairNo, changeType: 2)
    }
    
    func scorePlusLeft() -> Void {
        let isSwapped = (courtSwapped == 1)
        let pairList = isSwapped ? currentMatch?.pair2List : currentMatch?.pair1List
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.scoreDetailList?.last?.detailNo,
              let pairNo = pairList?.first?.pairNo else { return }
        adjustScore(matchNo: matchNo, detailNo: detailNo, pairNo: pairNo, changeType: 1)
    }
    
    func scoreMinusRight() -> Void {
        let isSwapped = (courtSwapped == 1)
        let pairList = isSwapped ? currentMatch?.pair1List : currentMatch?.pair2List
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.scoreDetailList?.last?.detailNo,
              let pairNo = pairList?.first?.pairNo else { return }
        adjustScore(matchNo: matchNo, detailNo: detailNo, pairNo: pairNo, changeType: 2)
    }
    
    func scorePlusRight() -> Void {
        let isSwapped = (courtSwapped == 1)
        let pairList = isSwapped ? currentMatch?.pair1List : currentMatch?.pair2List
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.scoreDetailList?.last?.detailNo,
              let pairNo = pairList?.first?.pairNo else { return }
        adjustScore(matchNo: matchNo, detailNo: detailNo, pairNo: pairNo, changeType: 1)
    }

    /// 获取热身状态
    func checkWarmupStatus(matchNo: String) {
        WyBadmintonRefereeAPI.getWarmupStatus(matchNo: matchNo)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.isValid {
                    self.isWarmedUp = response.data ?? false
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 更新热身时间
    func updateWarmupTime(matchNo: String, duration: Int32) {
        let request = WyRefereeWarmupUpdateRequest(matchNo: matchNo, warmupDuration: duration)
        WyBadmintonRefereeAPI.updateWarmupTime(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                if response.isValid {
                    self?.startWarmupCountdown(minutes: Int(duration))
                }
            })
            .disposed(by: disposeBag)
    }
    
    func startWarmupCountdown(minutes: Int) {
        self.isWarmingUpNow = true
        self.remainingWarmupSeconds = minutes * 60
        self.updateTimerString()
        
        self.countdownTimer?.cancel()
        self.countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingWarmupSeconds > 0 {
                    self.remainingWarmupSeconds -= 1
                    self.updateTimerString()
                } else {
                    self.endWarmup()
                }
            }
    }
    
    private func updateTimerString() {
        let h = remainingWarmupSeconds / 3600
        let m = (remainingWarmupSeconds % 3600) / 60
        let s = remainingWarmupSeconds % 60
        self.timerString = String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    private func endWarmup() {
        self.countdownTimer?.cancel()
        self.countdownTimer = nil
        self.isWarmingUpNow = false
        self.isWarmedUp = true
        self.timerString = "00:00:00"
    }
    
    // MARK: - 比赛计时器（正计时）
    
    func startMatchTimer() {
        self.matchElapsedSeconds = 0
        self.isPaused = false
        self.updateMatchTimerString()
        resumeMatchTimer()
    }
    
    private func resumeMatchTimer() {
        self.matchTimer?.cancel()
        self.matchTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.matchElapsedSeconds += 1
                self.updateMatchTimerString()
            }
    }
    
    private func updateMatchTimerString() {
        let h = matchElapsedSeconds / 3600
        let m = (matchElapsedSeconds % 3600) / 60
        let s = matchElapsedSeconds % 60
        self.timerString = String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    func stopMatchTimer() {
        self.matchTimer?.cancel()
        self.matchTimer = nil
    }
}
