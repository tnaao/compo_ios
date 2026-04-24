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
    @Published var role: SignatureRole = .winner
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSubmitSuccess: Bool = false
    
    private let disposeBag = DisposeBag()
    
    /// 保存签名：先截图上传，再提交签名URL
    func saveSignature(signatureView: some View, size: CGSize, matchNo: String) {
        isLoading = true
        
        // 1. 将签名视图渲染为图片
        guard let image = renderViewToImage(signatureView, size: size),
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
                    // 3. 上传成功，按角色递交签名接口
                    self.submitSign(matchNo: matchNo, signatureImageUrl: imageUrl)
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
    
    private func submitSign(matchNo: String, signatureImageUrl: String) {
        let request = WyRefereeSignatureRequest(matchNo: matchNo, signatureImage: signatureImageUrl)
        
        let apiCall = (role == .winner) ?
            WyBadmintonRefereeAPI.winnerSign(request: request) :
            WyBadmintonRefereeAPI.refereeSign(request: request)
            
        apiCall
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
    private func renderViewToImage(_ view: some View, size: CGSize) -> UIImage? {
        // 创建一个包装视图，确保有纯白背景且没有任何边界伪影
        let captureView = ZStack {
            Color.white
            view
        }
        .frame(width: size.width, height: size.height)
        .clipped()
        
        if #available(iOS 16.0, *) {
            let renderer = ImageRenderer(content: captureView)
            renderer.scale = UIScreen.main.scale
            renderer.isOpaque = true // 确保不透明
            return renderer.uiImage
        } else {
            let controller = UIHostingController(rootView: captureView)
            controller.view.bounds = CGRect(origin: .zero, size: size)
            controller.view.backgroundColor = .white
            controller.view.layoutIfNeeded()
            
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { _ in
                controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }
    }
}
