//
//  ViewUtil.swift
//  CompoApp
//
//  Created by GH w on 3/17/26.
//

import SwiftUI
import AdapterSwift

extension View {
  func loginBg() -> some View {
      bgImage("loginBg",contentMode: .fill).ignoresSafeArea()
    }
}

extension View {
      func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
      }
    
      @ViewBuilder
      func hideNavigationBar() -> some View {
          if #available(iOS 18.0, *) {
            toolbarVisibility(.hidden, for: .navigationBar)
          } else {
            self.navigationBarHidden(true)
          }
      }
    
    @ViewBuilder
    func bgImage(_ name:String,contentMode:ContentMode = .fit) -> some View {
        self.background {
            GeometryReader { geo in
                MyAssetImage(name: name,width: geo.size.width,height: geo.size.height,contentMode: contentMode)
            }
        }
    }
    
    @ViewBuilder
    func xVisible(_ v:Bool) -> some View {
        if v {
            self
        } else {
            EmptyView()
        }
    }
       
    @ViewBuilder
    func xDisplay(_ v: Bool) -> some View {
        if v {
            self.opacity(1.0)
        } else {
            self.opacity(0.0)
        }
    }
    
    @ViewBuilder
    func playerIconShadow(size:CGFloat=0) -> some View {
        ZStack(alignment: .center) {
            let radius = size/2
            Color.clear.frame(
                width: size,height: size
            ).xShadow(bgColor: Color.clear,radius: radius,innerBorderColor: Color(hex: "#CC6E5DFF"),innerBorderWidth: 0.5.adapter,blurColor: Color(hex: "#996E5DFF"),blur: 2)
            self
        }
    }
    
    @ViewBuilder
    func xShadow(bgColor:Color = .clear,radius:CGFloat=2,innerBorderColor:Color = .clear,innerBorderWidth:CGFloat=0,outerBorderColor:Color = .clear,outerBorderWidth:CGFloat = 0,blurColor:Color = .clear,blur:CGFloat = 0,x:CGFloat = 0,y:CGFloat = 0) -> some View{
        color(bgColor, cornerRadius: radius)
            .outerBorder(color: outerBorderColor, lineWidth: outerBorderWidth, cornerRadius: radius)
            .innerBorder(color: innerBorderColor, lineWidth: innerBorderWidth, cornerRadius: radius)
            .shadow(color: blurColor, blur: blur, x: x.adapter, y: y.adapter)
    }
    
    @ViewBuilder
    func color(_ color: Color, cornerRadius: CGFloat = 0) -> some View {
          self.modifier(ColorModifier(color: color, cornerRadius: cornerRadius))
    }
       
    @ViewBuilder
    func shadow(color: Color, blur: CGFloat, x: CGFloat,y:CGFloat) -> some View {
          self.modifier(ShadowModifier(color: color, blur: blur, x: x, y: y))
    }
     
    @ViewBuilder
    func innerBorder(color: Color, lineWidth: CGFloat, cornerRadius: CGFloat) -> some View {
          self.modifier(InnerBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
    
    @ViewBuilder
    func innerBorderCircle(color: Color, lineWidth: CGFloat) -> some View {
          self.modifier(InnerBorderCircleModifier(color: color, lineWidth: lineWidth))
    }
    
    @ViewBuilder
    func outerBorder(color: Color, lineWidth: CGFloat, cornerRadius: CGFloat) -> some View {
          self.modifier(OuterBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
        
    @ViewBuilder
    func outerBorderCircle(color: Color, lineWidth: CGFloat, cornerRadius: CGFloat) -> some View {
          self.modifier(OuterBorderCircleModifier(color: color, lineWidth: lineWidth))
    }

    func messageNotificationPopup(
        isPresented: Binding<Bool>,
        matchNo: String = "",
        reason: String = "弃权",
        content: String = "",
        onConfirm: (() -> Void)? = nil
    ) -> some View {
        self.overlay {
            if isPresented.wrappedValue {
                MessageNotificationPopupView(
                    isPresented: isPresented,
                    matchNo: matchNo,
                    selectedReason: reason,
                    messageContent: content,
                    onConfirm: onConfirm
                )
            }
        }
    }

    func courtChangePopup(
        isPresented: Binding<Bool>,
        oldCourt: String,
        newCourt: String,
        message: String,
        onConfirm: (() -> Void)? = nil
    ) -> some View {
        self.overlay {
            if isPresented.wrappedValue {
                CourtChangePopupView(
                    isPresented: isPresented,
                    oldCourt: oldCourt,
                    newCourt: newCourt,
                    messageContent: message,
                    onConfirm: onConfirm
                )
            }
        }
    }

    func courtMessageDetailPopup(
        isPresented: Binding<Bool>,
        message: AppBadmintonCourtMessageRespVO?,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.overlay {
            if isPresented.wrappedValue {
                CourtMessageDetailPopupView(
                    isPresented: isPresented,
                    message: message,
                    onDismiss: onDismiss
                )
            }
        }
    }
}

extension Button {
    func noClickEffect() -> some View {
        self.buttonStyle(NoPressEffectStyle())
    }
}

struct InnerBorderModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(color, lineWidth: lineWidth)
            )
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct InnerBorderCircleModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                    .strokeBorder(color, lineWidth: lineWidth)
            )
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct ColorModifier: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
            }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct OuterBorderModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct OuterBorderCircleModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                    .stroke(color, lineWidth: lineWidth)
            )
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct ShadowModifier: ViewModifier {
    var color: Color
    var blur: CGFloat
    var x: CGFloat
    var y: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(
                color: color, // 对应：阴影颜色 #14000000
                radius: blur / 2, // 对应：Effect blur 5.5pt
                x: x,           // 对应：Offset X 2pt
                y: y            // 对应：Offset Y 3pt
            )
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct NoPressEffectStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // The following line ensures no change in appearance based on the pressed state
            // If you did want an effect, you'd use configuration.isPressed
            .opacity(1.0)
    }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

struct SafeAreaInsetsKey: PreferenceKey {
  static var defaultValue = EdgeInsets()
  static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
    value = nextValue()
  }
}

extension View {
  func getSafeAreaInsets(_ safeInsets: Binding<EdgeInsets>) -> some View {
    background(
      GeometryReader { proxy in
        Color.clear
          .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
      }
      .onPreferenceChange(SafeAreaInsetsKey.self) { value in
        safeInsets.wrappedValue = value
      }
    )
  }
}



enum XdLoadingState {
  case loading
  case normal
  case failure
  case noData
}

extension View {
  /**
   显示加载状态
   - Parameters:
   - state: 加载状态
   - content: 内容
   - Returns: 一些视图
   */
  func xDisplayLoadingState(_ state: XdLoadingState)
    -> some View
  {
    ZStack {
      self
      Group {
        if state == .loading {
          loadingView
        }

        if state == .failure {
          failureView
        }

        if state == .noData {
          noDataView
        }
      }
    }
  }
}

private var loadingView: some View {
  VStack {
    Spacer()
    ProgressView("加载中...")
    Spacer()
  }
}

private var failureView: some View {
  VStack(spacing: 16.webPx) {
    Spacer()
    Image(systemName: "exclamationmark.triangle")
      .font(.system(size: 48.webPx))
      .foregroundColor(.gray)
    Text("加载失败")
      .font(.system(size: 28.webPx))
      .foregroundColor(.gray)
    Spacer()
  }
}

private var noDataView: some View {
  VStack(spacing: 16.webPx) {
    Spacer()
    Image(systemName: "mappin.slash")
      .font(.system(size: 48.webPx))
      .foregroundColor(.gray)
    Text("空空如也~")
      .font(.system(size: 28.webPx))
      .foregroundColor(.gray)
    Spacer()
  }
}

// MARK: - Load More Component

extension View {
  /// 加载更多触发器视图
  /// - Parameters:
  ///   - isLoading: 是否正在加载
  ///   - hasMore: 是否还有更多数据
  ///   - action: 加载更多回调
  /// - Returns: 加载更多视图
  @ViewBuilder
  func loadMoreTrigger(isLoading: Bool, hasMore: Bool, action: @escaping () -> Void) -> some View {
    if hasMore {
      HStack {
        Spacer()
        if isLoading {
          ProgressView()
            .scaleEffect(1.2)
        } else {
          Text("加载更多...")
            .font(.system(size: 24.webPx))
            .foregroundColor(Color(red: 132 / 255, green: 138 / 255, blue: 152 / 255))
        }
        Spacer()
      }
      .padding(.vertical, 24.webPx)
      .onAppear {
        if !isLoading {
          action()
        }
      }
    }
  }
}
