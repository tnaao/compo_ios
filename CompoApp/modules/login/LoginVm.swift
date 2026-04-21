//
//  LoginVm.swift
//  CompoApp
//
//  Created by Antigravity on 4/17/26.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

class LoginVm: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var isLoading: Bool = false
    
    private let disposeBag = DisposeBag()
    
    func login() {
        let phone = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let code = verificationCode.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !phone.isEmpty else {
            ScreenInfo.showInfo("请输入手机号")
            return
        }
        
        guard !code.isEmpty else {
            ScreenInfo.showInfo("请输入验证码")
            return
        }
        
        isLoading = true
        print("[LoginVm] Attempting login for \(phone)")
        
        UserAPI.smsLogin(mobile: phone, code: code)
            .flatMap { response -> Observable<BaseModel<UserModel>> in
                if response.isValid, let token = response.data {
                    print("[LoginVm] Login success, token received. Fetching user info...")
                    UserInfo.shared.token = token
                    return UserAPI.getUserInfo()
                } else {
                    let errorMsg = response.msg ?? "登录失败"
                    return Observable.error(NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMsg]))
                }
            }
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid, let user = response.data {
                    UserInfo.shared.user = user
                    print("[LoginVm] User info fetched: \(user.nickname ?? "Unknown")")
                    
                    // Navigate back or to home
                    DispatchQueue.main.async {
                        AppRouter.shared.appRouter.popNavigation()
                    }
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                print("[LoginVm] Error during login flow: \(error.localizedDescription)")
                // Error HUD is usually handled by APIManager.request's .do(onError:)
            })
            .disposed(by: disposeBag)
    }
}
