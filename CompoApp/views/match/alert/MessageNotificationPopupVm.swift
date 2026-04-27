//
//  MessageNotificationPopupVm.swift
//  CompoApp
//
//  Created by Antigravity on 4/27/26.
//

import Foundation
import RxSwift
import Combine

class MessageNotificationPopupVm: ObservableObject {
    @Published var selectedReason: String = ""
    @Published var messageContent: String = ""
    @Published var isLoading: Bool = false
    @Published var isPresented: Bool = false
    
    var matchNo: String = ""
    var onConfirm: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    let reasonOptions = ["到场", "弃权", "受伤", "暂停"]
    
    func setup(matchNo: String, content: String, reason: String, onConfirm: (() -> Void)?) {
        self.matchNo = matchNo
        self.messageContent = content
        self.selectedReason = reason
        self.onConfirm = onConfirm
    }
    
    func submitMessage() {
        guard !matchNo.isEmpty else {
            ScreenInfo.showInfo("比赛编号不能为空")
            return
        }
        
        guard !selectedReason.isEmpty else {
            ScreenInfo.showInfo("请选择消息类型")
            return
        }
        
        isLoading = true
        let request = AppBadmintonCourtMessageCreateReqVO(
            matchNo: matchNo,
            messageType: selectedReason,
            messageContent: messageContent
        )
        
        WyBadmintonRefereeAPI.createMatchMessage(request: request)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid {
                    ScreenInfo.showSuccess("消息已发送")
                    self.onConfirm?()
                    self.isPresented = false
                } else {
                    ScreenInfo.showError(response.msg ?? "发送失败")
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                ScreenInfo.showError("网络错误：\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
