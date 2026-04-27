import SwiftUI
import UIKit

// MARK: - Preference Key
struct XPRScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

// MARK: - Custom Spinner View
struct RefreshActivityIndicator: View {
    var rotation: Double
    var isRefreshing: Bool
    var pullProgress: CGFloat
    
    // 1. Add a local state to drive the continuous animation
    @State private var animRotation: Double = 0

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 3)
                    .frame(width: 30, height: 30)

                Circle()
                    .trim(from: 0, to: isRefreshing ? 0.7 : min(pullProgress * 0.7, 0.7))
                    .stroke(Color.loadingIndicatorColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 30, height: 30)
                    // 2. Use pull progress when dragging, and animRotation when refreshing
                    .rotationEffect(Angle(degrees: isRefreshing ? animRotation : Double(pullProgress * 180)))
            }

            Text(isRefreshing ? "刷新中.." : (pullProgress > 1.0 ? "松手刷新" : "下拉刷新"))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 10)
        // 3. Listen for the refresh state change to start/stop the loop
        .onChange(of: isRefreshing) { refreshing in
            if refreshing {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    animRotation = 360
                }
            } else {
                animRotation = 0
            }
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

// MARK: - Refresh Header Logic
struct XPRefreshHeader: View {
  var threshold: CGFloat = 50
  let onRefresh: () -> Void
  @State private var isRefreshing = false

  var body: some View {
    GeometryReader { geo in
      let offset = geo.frame(in: .named("scroll")).minY

      Color.clear
        .preference(key: XPRScrollOffsetPreferenceKey.self, value: offset)
        .onChange(of: offset) { newValue in
          if newValue > threshold && !isRefreshing {
            isRefreshing = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            onRefresh()
          } else if newValue <= 0 {
            isRefreshing = false
          }
        }
    }
    .frame(height: 0)
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// MARK: - Main List Wrapper
struct SwipeToRefreshListView<T: Identifiable, V: View>: View {
  var items: [T]
  let itemContent:(Int,T) -> V
  var spacing = 32.webPx
  @Binding var isRefreshing: Bool
  var onRefresh: () -> Void
  @State private var currentOffset: Double = 0
  private let threshold: CGFloat = 50

  // Custom Init to handle the builder pattern
  init(
    _ items: [T],
    isRefreshing: Binding<Bool>,
    spacing:CGFloat = 16.webPx,
    @ViewBuilder itemContent: @escaping (Int,T) -> V
  ) {
      self.items = items
      self._isRefreshing = isRefreshing
      self.onRefresh = {}
      self.spacing = spacing
      self.itemContent = itemContent
  }

  var body: some View {
      ScrollView(.vertical,showsIndicators: false) {
      ZStack(alignment: .top) {
        // Logic
        XPRefreshHeader(threshold: threshold) {
          withAnimation { isRefreshing = true }
          // Simulate a delay for the animation before calling data refresh
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                /*isRefreshing = false*/ }
          }
            DispatchQueue.main.asyncAfter(deadline: .now()+1.2, execute: {
                onRefresh()
            })
        }

        // Header Visuals
        RefreshActivityIndicator(
          rotation: currentOffset,
          isRefreshing: isRefreshing,
          pullProgress: currentOffset / threshold
        )
        .offset(y: isRefreshing ? 0 : CGFloat(-1*(threshold+20)) + min(currentOffset, CGFloat(50 + 20)))
        .opacity(currentOffset > 5 || isRefreshing ? 1 : 0).xVisible(true)

        // List Content
        LazyVStack(spacing: spacing) {
          // Spacer to make room for spinner
          if isRefreshing {
              RefreshActivityIndicator(
                rotation: currentOffset,
                isRefreshing: isRefreshing,
                pullProgress: currentOffset / threshold
              ).xDisplay(false).frame(height: (threshold+20))
          }
            
            ForEach(Array(items.enumerated()), id: \.element.id) { element in
                itemContent(element.offset, element.element)
            Color.clear.fixedSize().frame(maxWidth: .infinity)
                  .frame(height: CGFloat(0.1))
          }
        }
      }
    }
    .coordinateSpace(name: "scroll")
    .onPreferenceChange(XPRScrollOffsetPreferenceKey.self) { value in
      currentOffset = value
    }
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}


// MARK: - Main List Wrapper
struct XPSimpleSwipeToRefreshListView<T: Identifiable, V: View>: View {
  var items: [T]
  let itemContent: (Int,T) -> V
  var spacing = 32.webPx
  var onRefresh: () -> Void
  @State private var isRefreshing: Bool = false
  @State private var currentOffset: Double = 0
  private let threshold: CGFloat = 50

  // Custom Init to handle the builder pattern
  init(
    _ items: [T],
    spacing:CGFloat = 16.webPx,
    @ViewBuilder itemContent: @escaping (Int,T) -> V
  ) {
      self.items = items
      self.onRefresh = {}
      self.spacing = spacing
      self.itemContent = itemContent
  }

  var body: some View {
    ScrollView {
      ZStack(alignment: .top) {
        // Logic
        XPRefreshHeader(threshold: threshold) {
          withAnimation { isRefreshing = true }
          // Simulate a delay for the animation before calling data refresh
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isRefreshing = false }
          }
            DispatchQueue.main.asyncAfter(deadline: .now()+1.2, execute: {
                onRefresh()
            })
        }

        // Header Visuals
        RefreshActivityIndicator(
          rotation: currentOffset,
          isRefreshing: isRefreshing,
          pullProgress: currentOffset / threshold
        )
        .offset(y: isRefreshing ? 0 : CGFloat(-1*(threshold+20)) + min(currentOffset, CGFloat(50 + 20)))
        .opacity(currentOffset > 5 || isRefreshing ? 1 : 0).xVisible(true)

        // List Content
        LazyVStack(spacing: spacing) {
          // Spacer to make room for spinner
          if isRefreshing {
              RefreshActivityIndicator(
                rotation: currentOffset,
                isRefreshing: isRefreshing,
                pullProgress: currentOffset / threshold
              ).xDisplay(false).padding().frame(height: (threshold+20))
          }
            
            ForEach(Array(items.enumerated()), id: \.element.id) { element in
            itemContent(element.offset, element.element)
            Color.clear.fixedSize().frame(maxWidth: .infinity)
                  .frame(height: CGFloat(0.1))
          }
        }
        .padding()
      }
    }
    .coordinateSpace(name: "scroll")
    .onPreferenceChange(XPRScrollOffsetPreferenceKey.self) { value in
      currentOffset = value
    }
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}


// MARK: - Builder Extension
extension SwipeToRefreshListView {
  func onRefresh(_ action: @escaping () -> Void) -> SwipeToRefreshListView {
    var copy = self
    copy.onRefresh = action
    return copy
  }
}

// MARK: - Builder Extension
extension XPSimpleSwipeToRefreshListView {
  func onRefresh(_ action: @escaping () -> Void) -> XPSimpleSwipeToRefreshListView {
    var copy = self
    copy.onRefresh = action
    return copy
  }
}

// MARK: - Generic Scroll Wrapper
struct SwipeToRefreshScrollView<Content: View>: View {
  let content: Content
  @Binding var isRefreshing: Bool
  var onRefresh: () -> Void

  @State private var currentOffset: Double = 0
  private let threshold: CGFloat = 50

  init(
    isRefreshing: Binding<Bool>,
    onRefresh: @escaping () -> Void,
    @ViewBuilder content: () -> Content
  ) {
    self._isRefreshing = isRefreshing
    self.onRefresh = onRefresh
    self.content = content()
  }

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      ZStack(alignment: .top) {
        // Logic
        XPRefreshHeader(threshold: threshold) {
          withAnimation { isRefreshing = true }
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            onRefresh()
          }
        }

        // Header Visuals
        RefreshActivityIndicator(
          rotation: currentOffset,
          isRefreshing: isRefreshing,
          pullProgress: currentOffset / threshold
        )
        .offset(y: isRefreshing ? 0 : CGFloat(-1*(threshold+20)) + min(currentOffset, CGFloat(50 + 20)))
        .opacity(currentOffset > 5 || isRefreshing ? 1 : 0).xVisible(true)

        // Content Wrapper
        VStack(spacing: 0) {
          if isRefreshing {
            RefreshActivityIndicator(
              rotation: currentOffset,
              isRefreshing: isRefreshing,
              pullProgress: currentOffset / threshold
            ).xDisplay(false).frame(height: (threshold+20))
          }
            
          content
        }
      }
    }
    .coordinateSpace(name: "scroll")
    .onPreferenceChange(XPRScrollOffsetPreferenceKey.self) { value in
      currentOffset = value
    }
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

struct SimpleListItem:Equatable,Identifiable {
 var title:String
    var id: String {
        self.title
    }
}
// MARK: - Implementation Example
struct SwipeToRefreshExample: View {
  @State var list: [SimpleListItem] = (1...5).map { SimpleListItem(title: "Item \($0)") }
  var body: some View {
    NavigationView {
        XPSimpleSwipeToRefreshListView(list,spacing: 16.webPx) { index,item in
        //单个条目
            Text(item.title)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .background(Color(.lightGray))
          .cornerRadius(10)
          .frame(height: 88.webPx)
      }
      .onRefresh {
        //调用获取数据接口
        let newItems = (list.count + 1...10 + 5).map { SimpleListItem(title:  "Item \($0)") }
        list.append(contentsOf: newItems)
      }
      .navigationTitle("ZSwing Refresh")
    }
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

@available(iOS 17.0, *)
#Preview {
  SwipeToRefreshExample()
}
