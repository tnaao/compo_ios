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
enum CheckInStatus: Int {
    case unchecked = 0 // 未检
    case checked = 1   // 已检
    case forfeited = 2 // 弃权
    
    var title: String {
        switch self {
        case .unchecked: return "未检"
        case .checked: return "已检"
        case .forfeited: return "弃权"
        }
    }
}

@MainActor
class MatchScoringStore: ObservableObject {

    static let shared = MatchScoringStore()

    @Published var scoreDetail: WyRefereeMatchScoreDetailModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isActionSuccess: Bool = false
    @Published var showEarlyEndConfirm: Bool = false
    
    @Published var currentEvent:BadmintonCompetitionRespVO? = nil
    @Published var currentMatch:WyBadmintonScheduleProgramModel? = nil {
        didSet {
            if oldValue?.matchNo != currentMatch?.matchNo {
                resetMatchState()
            }
        }
    }
    
    @Published var isWarmedUp: Bool = false {
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
    
    @Published var totalRounds: Int = 3
    @Published var currentSetNumber: Int = 1
    @Published var runningState: MatchRunningState = .notStarted
    
    @Published var firstServer: Int32? = nil
    @Published var firstServerId: Int64? = nil
    @Published var courtSwapped: Int32? = 0
    let autoCourtSwap = false
    @Published var showWarmupPopup: Bool = false
    @Published var showMatchResult: Bool = false
    @Published var showConfirmBegin: Bool = false
    @Published var showConfirmEnd: Bool = false
    @Published var isEndingFlow: Bool = false
    @Published var earlyEndWinnerName: String = ""
    
    // Court Message Polling
    private var messagePollingTimer: AnyCancellable?
    @Published var unreadMessage: AppBadmintonCourtMessageRespVO? = nil
    @Published var unreadCount: Int = 0
    @Published var showMessageDetailPopup: Bool = false
    
    private var hasTriggeredAutoNav: Bool = false
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
    
    var team1Name: String {
        guard let p1List = currentMatch?.pair1List, !p1List.isEmpty else { return "队伍1" }
        return p1List.map { $0.playerName }.joined(separator: "/")
    }
    
    var team2Name: String {
        guard let p2List = currentMatch?.pair2List, !p2List.isEmpty else { return "队伍2" }
        return p2List.map { $0.playerName }.joined(separator: "/")
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
        var matchStatus:Int32 = 0
        let matchParentStatus = scoreDetail?.matchStatus
        self.totalRounds = Int(scoreDetail?.totalRounds ?? 3)
        if let lastRound = scoreDetail?.scoreDetailList?.first(where: { item in
            guard let s1 = item.player1Score, let s2 = item.player2Score else { return true }
            let notEnd = item.roundStatus != 2
            return s1 + s2 < 1 || notEnd
        }) {
            let setNumber = lastRound.roundNumber ?? 1
            self.currentSetNumber = Int(setNumber)
            // Automatically detect court swap based on badminton rules
            var shouldBeSwapped = (setNumber % 2 == 0)
            if setNumber >= totalRounds && totalRounds > 1 {
                let p1s = lastRound.player1Score ?? 0
                let p2s = lastRound.player2Score ?? 0
                if p1s >= 11 || p2s >= 11 {
                    shouldBeSwapped.toggle()
                }
            }
            if autoCourtSwap {
                self.courtSwapped = shouldBeSwapped ? 1 : 0
            } else {
                self.courtSwapped = lastRound.courtSwapped
            }
            
            self.firstServer = lastRound.firstServer
            self.pendingServeTeam = lastRound.firstServer
            
            let s1 = lastRound.player1Score ?? Int32(0)
            let s2 = lastRound.player2Score ?? Int32(0)
            if scoreDetail?.scoreDetailList?.firstIndex(of: lastRound) == 2 && (s1 + s2) >= 1{
                matchStatus = matchParentStatus ?? Int32(lastRound.roundStatus ?? 0)
            }else {
                matchStatus = Int32(lastRound.roundStatus ?? 0)
            }
        }else {
            matchStatus = matchParentStatus ??  2
            self.currentSetNumber = scoreDetail?.scoreDetailList?.count ?? 1
        }
        
        let mStatus = matchStatus
        if mStatus == 2 || mStatus == 3 {
            self.runningState = .finished
            nextSetNumber()
        } else if mStatus == 1 {
            self.runningState = .playing
        } else {
            if isWarmingUpNow {
                self.runningState = .warmingUp
            } else {
                self.runningState = .notStarted
            }
        }

        // 当整场比赛结束时，如果是从计分页触发的，则3秒后自动跳转到签名确认页
        if scoreDetail?.matchStatus == 2 {
            self.autoNavigateToSignatureConfirm()
        }
    }

    private func autoNavigateToSignatureConfirm() {
        guard !hasTriggeredAutoNav else { return }
        hasTriggeredAutoNav = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            // 确保当前还在计分页
            let currentPath = AppRouter.shared.appRouter.path
            if let last = currentPath.last, case .matchScoring = last {
                AppRouter.shared.appRouter.navigateTo(.matchSignatureConfirm)
            }
        }
    }
    
    /// 清除比分和计时器状态
    func resetMatchState() {
        self.scoreDetail = nil
        self.isWarmedUp = true
        self.isWarmingUpNow = false
        self.showWarmupPopup = false
        self.showMatchResult = false
        self.showConfirmBegin = false
        self.showConfirmEnd = false
        self.pendingServeTeam = nil
        
        self.timerString = "00:00:00"
        self.currentSetNumber = 1
        self.runningState = .notStarted
        self.firstServer = nil
        self.firstServerId = nil
        self.courtSwapped = 0
        
        // 清除热身倒计时
        self.countdownTimer?.cancel()
        self.countdownTimer = nil
        self.remainingWarmupSeconds = 0
        
        // 清除比赛正计时
        self.matchTimer?.cancel()
        self.matchTimer = nil
        self.matchElapsedSeconds = 0
        self.isPaused = false
        self.hasTriggeredAutoNav = false
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
                    self.runningState = .playing
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
            .flatMap { [weak self] response -> Observable<BaseModel<WyRefereeMatchScoreDetailModel>> in
                guard let self = self else { return .empty() }
                if response.isValid {
                    return Observable.just(())
                        .delay(.seconds(2), scheduler: MainScheduler.instance)
                        .flatMap { _ in WyBadmintonRefereeAPI.getMatchScoreDetail(matchNo: matchNo) }
                } else {
                    return .error(NSError(domain: "MatchError", code: -1, userInfo: [NSLocalizedDescriptionKey: response.message ?? "结束比赛失败"]))
                }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid, let detail = response.data {
                    self.isActionSuccess = true
                    let oldSetNumber = self.currentSetNumber
                    self.scoreDetail = detail
                    self.syncRunningState()
                    
                    // Check for early end after winning required number of sets
                    let winThreshold = (totalRounds / 2) + 1
                    if oldSetNumber < totalRounds {
                        let s1 = detail.pair1Score ?? 0
                        let s2 = detail.pair2Score ?? 0
                        if s1 == winThreshold || s2 == winThreshold {
                            self.earlyEndWinnerName = (s1 == winThreshold) ? self.team1Name : self.team2Name
                            self.showEarlyEndConfirm = true
                            return
                        }
                    }
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func confirmEarlyEnd() {
        self.showEarlyEndConfirm = false
        guard let matchNo = currentMatch?.matchNo,
              let scoreDetail = scoreDetail,
              let scoreDetailList = scoreDetail.scoreDetailList else { return }
        
        let remainingSets = scoreDetailList.filter { ($0.roundStatus ?? 0) == 0 }
        
        if remainingSets.isEmpty { return }
        
        isLoading = true
        
        // Skip all remaining sets
        Observable.from(remainingSets)
            .concatMap { [weak self] set -> Observable<BaseModel<Bool>> in
                guard let self = self else { return .empty() }
                let request = WyRefereeScoreAdjustDetailRequest(
                    matchNo: matchNo,
                    detailNo: set.detailNo ?? "",
                    firstServer: self.firstServer,
                    courtSwapped: self.courtSwapped
                )
                return WyBadmintonRefereeAPI.skipScoreDetail(request: request)
            }
            .ignoreElements()
            .asCompletable()
            .andThen(
                Observable.just(())
                    .delay(.seconds(2), scheduler: MainScheduler.instance)
                    .flatMap { _ in WyBadmintonRefereeAPI.getMatchScoreDetail(matchNo: matchNo) }
            )
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid, let detail = response.data {
                    self.isActionSuccess = true
                    self.scoreDetail = detail
                    self.syncRunningState()
                    self.showMatchResult = true
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func cancelEarlyEnd() {
        self.showEarlyEndConfirm = false
    }
    
    func actionPlay() -> Void {
        if isWarmingUpNow {
            ScreenInfo.showInfo("热身中")
            return
        }
        if self.currentSetNumber == 1 && !self.isWarmedUp {
            self.showWarmupPopup = true
        }else {
            self.showConfirmBegin = true
        }
    }
    
    func actionStartServe(playerId: Int64, team: Int32) {
        self.firstServer = team
        self.firstServerId = playerId
        guard runningState == .notStarted || runningState == .warmingUp else { return }
        self.pendingServeTeam = team
    }
    
    func confirmStartMatch() {
        let team = pendingServeTeam ?? 1
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.getSetScore(by: currentSetNumber)?.detailNo else {
            return
        }
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
        self.isEndingFlow = true
        self.showMatchResult = true
    }
    
    func confirmEndMatch() {
        self.showConfirmEnd = false
        stopMatchTimer()
        isPaused = false
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.getSetScore(by: self.currentSetNumber)?.detailNo else { return }
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
                    
                    if self.isEndingFlow {
                        self.showConfirmEnd = true
                        self.isEndingFlow = false
                    }
                    
                    if let matchNo = self.currentMatch?.matchNo {
//                        self.fetchMatchScoreDetail(matchNo: matchNo)
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
    
    func nextSetNumber(){
        if self.currentSetNumber >= totalRounds { return }
        self.currentSetNumber += 1
        self.runningState = .notStarted
    }
    
    func actionChangeSwitch() -> Void {
        let current = courtSwapped ?? 0
        courtSwapped = (current == 0) ? 1 : 0
    }
    
    func scoreMinusLeft() -> Void {
        let isSwapped = (courtSwapped == 1)
        let pairList = isSwapped ? currentMatch?.pair2List : currentMatch?.pair1List
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.getSetScore(by: self.currentSetNumber)?.detailNo,
              let pairNo = pairList?.first?.pairNo else { return }
        adjustScore(matchNo: matchNo, detailNo: detailNo, pairNo: pairNo, changeType: 2)
    }
    
    func scorePlusLeft() -> Void {
        let isSwapped = (courtSwapped == 1)
        let pairList = isSwapped ? currentMatch?.pair2List : currentMatch?.pair1List
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.getSetScore(by: self.currentSetNumber)?.detailNo,
              let pairNo = pairList?.first?.pairNo else { return }
        adjustScore(matchNo: matchNo, detailNo: detailNo, pairNo: pairNo, changeType: 1)
    }
    
    func scoreMinusRight() -> Void {
        let isSwapped = (courtSwapped == 1)
        let pairList = isSwapped ? currentMatch?.pair1List : currentMatch?.pair2List
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.getSetScore(by: self.currentSetNumber)?.detailNo,
              let pairNo = pairList?.first?.pairNo else { return }
        adjustScore(matchNo: matchNo, detailNo: detailNo, pairNo: pairNo, changeType: 2)
    }
    
    func scorePlusRight() -> Void {
        let isSwapped = (courtSwapped == 1)
        let pairList = isSwapped ? currentMatch?.pair1List : currentMatch?.pair2List
        guard let matchNo = currentMatch?.matchNo,
              let detailNo = scoreDetail?.getSetScore(by: self.currentSetNumber)?.detailNo,
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
                    self?.startWarmupCountdown(minutes: duration)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func startWarmupCountdown(minutes: Int32) {
        self.isWarmingUpNow = true
        self.remainingWarmupSeconds = Int(minutes) * 60
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
    
    // MARK: - Court Message Polling Logic
    
    func startMessagePolling() {
        self.stopMessagePolling()
        
        // Initial fetch
        self.fetchUnreadMessages()
        
        // Setup timer for 2 minutes (120 seconds)
        self.messagePollingTimer = Timer.publish(every: 120, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchUnreadMessages()
            }
    }
    
    func stopMessagePolling() {
        self.messagePollingTimer?.cancel()
        self.messagePollingTimer = nil
    }
    
    func fetchUnreadMessages() {
        guard let competitionNo = currentEvent?.competitionNo else { return }
        
        WyBadmintonRefereeAPI.getMatchMessagePage(competitionNo: competitionNo, readStatus: "0", pageNo: 1, pageSize: 1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.isValid {
                    self.unreadCount = Int(response.data?.total ?? 0)
                    if let list = response.data?.list, !list.isEmpty {
                        let firstMsg = list[0]
                        self.fetchMessageDetail(messageId: firstMsg.messageId)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchMessageDetail(messageId: Int64) {
        WyBadmintonRefereeAPI.getMessageDetailById(messageId: messageId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.isValid {
                    self.unreadMessage = response.data
                    self.showMessageDetailPopup = true
                }
            })
            .disposed(by: disposeBag)
    }
}
