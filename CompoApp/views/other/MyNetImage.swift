//
//  MyNetImage.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//
import SwiftUI
import Kingfisher

struct MyNetImage: View {
  var url: String? = nil
  var placeHolderName: String? = "matchDefault"
  private let urlDefault: String = "https://theportablewife.com/wp-content/uploads/best-places-to-take-pictures-in-paris-newfeatured.jpg"
  var width: CGFloat = CGFloat.infinity
  var height: CGFloat = CGFloat.infinity
  var radius: CGFloat = 0
  var contentMode: SwiftUI.ContentMode = .fill
  var isOval: Bool = false
  var bgColor: Color = Color.gray.opacity(0.3)
  var timeOutWait: Double = 5.0
  var onImageLoaded: ((UIImage?) -> Void)? = nil

  /// 处理图片URL，将不支持的格式转换为支持的格式
  private var processedURL: String {
    guard let urlString = url else { return urlDefault }
    return urlString
  }

  var body: some View {
    let rc = isOval ? height * 0.5 : radius
    Group {
      if bgColor != .clear {
        RoundedRectangle(cornerRadius: rc)
          .fill(bgColor)
      } else {
        Color.clear
      }
    }
    .frame(minWidth: 1.webPx, minHeight: 1.webPx)
    .frame(width: width, height: height)
    .overlay {
      CustomAsyncImage(
        url: processedURL,
        width: width,
        height: height,
        radius: rc,
        contentMode: contentMode,
        timeOutWait: timeOutWait,
        onImageLoaded: onImageLoaded,
        placeHolderName: placeHolderName
      )
      .id(processedURL)
    }
    .enableInjection()
  }
}

struct CustomAsyncImage: View {
  let url: String
  let width: CGFloat
  let height: CGFloat
  let radius: CGFloat
  var contentMode: ContentMode = .fill
  var timeOutWait: Double = 5.0
  var onImageLoaded: ((UIImage?) -> Void)?
  var placeHolderName: String? = nil

  @State private var isLoadError = false
  @State private var isLoadTimeout = false

  var body: some View {
    Group {
      if isLoadError {
        errorView.xVisible(isLoadTimeout)
      } else {
        kfImageView
      }
    }.onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + timeOutWait) {
        isLoadTimeout = true
      }
    }
  }

  @ViewBuilder
  private var kfImageView: some View {
    KFImage(URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? url))
      .resizable()
      .onSuccess { result in
        isLoadError = false
        onImageLoaded?(result.image)
      }
      .onFailure { _ in
        isLoadError = true
        onImageLoaded?(nil)
      }
      .placeholder {
        placeholderView
      }
      .fade(duration: 0.3)
      .aspectRatio(contentMode: contentMode)
      .frame(width: width, height: height)
      .clipShape(RoundedCorner(radius: radius))
  }

  @ViewBuilder
  private var placeholderView: some View {
    baseIconView(isError: false)
  }

  @ViewBuilder
  private var errorView: some View {
    baseIconView(isError: true)
  }

  @ViewBuilder
  private func baseIconView(isError: Bool) -> some View {
    Group {
      if let name = placeHolderName, name.isNotBlank {
        if isError {
          Image(name)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: width, height: height)
            .foregroundColor(.gray.opacity(0.5))
            .clipped()
        } else {
          Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(width > 0 && width != .infinity ? width * 0.2 : 20)
            .foregroundColor(.gray.opacity(0.5))
        }
      } else {
        Image(systemName: "photo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(width > 0 && width != .infinity ? width * 0.2 : 20)
          .foregroundColor(.gray.opacity(0.5))
      }
    }
    .frame(width: width, height: height)
    .clipShape(RoundedCorner(radius: radius))
  }
}
