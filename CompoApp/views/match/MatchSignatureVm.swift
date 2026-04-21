//
//  MatchSignatureVm.swift
//  CompoApp
//
//  Created by Antigravity on 4/21/26.
//

import Foundation
import SwiftUI
import RxSwift
import Combine

@MainActor
class MatchSignatureVm: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSubmitSuccess: Bool = false
    
    private let disposeBag = DisposeBag()
    
    /// 保存签名：先截图上传，再提交签名URL
    func saveSignature(signatureView: some View, matchNo: String) {
        isLoading = true
        
        // 1. 将签名视图渲染为图片
        guard let image = renderViewToImage(signatureView),
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            self.isLoading = false
            self.errorMessage = "签名图片生成失败"
            return
        }
        
        let fileName = "signature_\(matchNo)_\(Int(Date().timeIntervalSince1970)).jpg"
        
        // 2. 上传图片
        UploadAPI.uploadImage(imageData: imageData, fileName: fileName)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.isValid, let imageUrl = response.data {
                    // 3. 上传成功，调用胜方签名接口
                    self.submitWinnerSign(matchNo: matchNo, signatureImageUrl: imageUrl)
                } else {
                    self.isLoading = false
                    self.errorMessage = response.msg ?? "上传签名图片失败"
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    /// 提交胜方签名
    private func submitWinnerSign(matchNo: String, signatureImageUrl: String) {
        let request = WyRefereeSignatureRequest(matchNo: matchNo, signatureImage: signatureImageUrl)
        WyBadmintonRefereeAPI.winnerSign(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.isValid {
                    self.isSubmitSuccess = true
                } else {
                    self.errorMessage = response.message ?? "提交签名失败"
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    /// 将 SwiftUI View 渲染为 UIImage
    private func renderViewToImage(_ view: some View) -> UIImage? {
        let controller = UIHostingController(rootView: view)
        let targetSize = CGSize(width: 400, height: 200)
        controller.view.bounds = CGRect(origin: .zero, size: targetSize)
        controller.view.backgroundColor = .white
        controller.view.layoutIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
