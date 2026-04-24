import AdapterSwift
import SwiftUI

// Custom shape for slanted buttons
struct SlantedButtonShape: Shape {
    enum SlantType {
        case leftRoundedRightSlanted
        case bothSlanted
        case leftSlantedRightRounded
    }
    
    let type: SlantType
    let slantOffset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let h = rect.height
        let w = rect.width
        let r = h / 2 // radius for rounded ends
        
        switch type {
        case .leftRoundedRightSlanted:
            // Left is rounded, right is slanted "/"
            path.move(to: CGPoint(x: r, y: 0))
            path.addLine(to: CGPoint(x: w, y: 0))
            path.addLine(to: CGPoint(x: w - slantOffset, y: h))
            path.addLine(to: CGPoint(x: r, y: h))
            path.addArc(center: CGPoint(x: r, y: r), radius: r, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: false)
            
        case .bothSlanted:
            // Both sides slanted "/"
            path.move(to: CGPoint(x: slantOffset, y: 0))
            path.addLine(to: CGPoint(x: w, y: 0))
            path.addLine(to: CGPoint(x: w - slantOffset, y: h))
            path.addLine(to: CGPoint(x: 0, y: h))
            
        case .leftSlantedRightRounded:
            // Left slanted "/", right rounded
            path.move(to: CGPoint(x: slantOffset, y: 0))
            path.addLine(to: CGPoint(x: w - r, y: 0))
            path.addArc(center: CGPoint(x: w - r, y: r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: h))
        }
        
        path.closeSubpath()
        return path
    }
}

// Simple Drawing Canvas
struct SignaturePadView: View {
    @Binding var lines: [[CGPoint]]
    @State private var currentLine = [CGPoint]()

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for line in lines {
                    guard let firstPoint = line.first else { continue }
                    path.move(to: firstPoint)
                    for point in line.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                if let firstPoint = currentLine.first {
                    path.move(to: firstPoint)
                    for point in currentLine.dropFirst() {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(Color.black, style: StrokeStyle(lineWidth: 3.adapter, lineCap: .round, lineJoin: .round))
            .background(Color.clear)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged { value in
                        let newPoint = value.location
                        currentLine.append(newPoint)
                    }
                    .onEnded { _ in
                        lines.append(currentLine)
                        currentLine = []
                    }
            )
        }
        .clipped()
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
    
    // clear is handled by parent clearing the binding
}

enum SignatureRole: String {
    case winner = "胜方签名"
    case referee = "裁判签名"
}

struct MatchSignatureView: View {
    var placeholderName: String = ""
    var role: SignatureRole = .winner
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @State private var lines = [[CGPoint]]()
    @State private var hideExistingSignature: Bool = false
    @State private var signatureSize: CGSize = .zero
    @StateObject private var scoreStore: MatchScoringStore = MatchScoringStore.shared
    @StateObject private var viewModel = MatchSignatureVm()
    
    var existingSignatureUrl: String? {
        if hideExistingSignature { return nil }
        if role == .referee {
            return scoreStore.scoreDetail?.refereeSignature
        } else {
            return scoreStore.scoreDetail?.winnerSignature
        }
    }
    
    var signatureNameText: String {
        if role == .referee {
            return UserInfo.shared.user?.nickname ?? "裁判"
        } else {
            guard let p1s = scoreStore.currentMatch?.pair1Score,
                  let p2s = scoreStore.currentMatch?.pair2Score else { return "胜方" }
            if p1s > p2s {
                return scoreStore.currentMatch?.pair1List?.map { $0.playerName }.joined(separator: "/") ?? "胜方"
            } else if p2s > p1s {
                return scoreStore.currentMatch?.pair2List?.map { $0.playerName }.joined(separator: "/") ?? "胜方"
            } else {
                return "胜方"
            }
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Navigation Bar
                navigationBar.padding(.top, safeAreaInsets.top)
                Spacer().fixedSize().frame(height: 10.adapter)
                // Signature Area
                VStack {
                    ZStack {
                        // Transparent container, relying on VStack white background
                        Color.clear
                        
                        VStack {
                            HStack {
                                Text(role.rawValue)
                                    .font(.system(size: 14.adapter, weight: .regular))
                                    .foregroundColor(Color(red: 102 / 255, green: 102 / 255, blue: 102 / 255))
                                    .padding(.leading, 20.adapter)
                                    .padding(.top, 20.adapter)
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        Text(signatureNameText)
                            .font(.system(size: 20.adapter, weight: .regular))
                            .foregroundColor(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255)) // Very faint gray
                        
                        if let url = existingSignatureUrl, !url.isEmpty {
                            MyNetImage(url: url, width: 400.adapter, height: 200.adapter, contentMode: .fit, bgColor: .clear)
                        }
                        
                        SignaturePadView(lines: $lines)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .background(GeometryReader { geo in
                        Color.clear.onAppear {
                            signatureSize = geo.size
                        }
                    })
                    
                    // Bottom Action Area
                    HStack(spacing: 8.adapter) {
                        // Clear Button
                        Button(action: {
                            lines.removeAll()
                            hideExistingSignature = true
                        }) {
                            Text("清除")
                                .font(.system(size: 14.adapter, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 90.adapter, height: 36.adapter)
                                .background(
                                    SlantedButtonShape(type: .leftRoundedRightSlanted, slantOffset: 12.adapter)
                                        .fill(Color(red: 255 / 255, green: 90 / 255, blue: 90 / 255))
                                )
                        }.noClickEffect()
                        
                        // Save Button
                        Button(action: {
                            guard let matchNo = scoreStore.currentMatch?.matchNo else { return }
                            let signatureView = SignaturePadView(lines: .constant(lines))
                            viewModel.saveSignature(signatureView: signatureView, size: signatureSize, matchNo: matchNo)
                        }) {
                            Text("保存")
                                .font(.system(size: 14.adapter, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 90.adapter, height: 36.adapter)
                                .background(
                                    SlantedButtonShape(type: .bothSlanted, slantOffset: 12.adapter)
                                        .fill(Color(red: 250 / 255, green: 139 / 255, blue: 44 / 255))
                                )
                        }.noClickEffect()
                        .disabled(viewModel.isLoading)
                        
                        // Return Button
                        Button(action: {
                            AppRouter.shared.appRouter.popNavigation()
                        }) {
                            Text("返回")
                                .font(.system(size: 14.adapter, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 90.adapter, height: 36.adapter)
                                .background(
                                    SlantedButtonShape(type: .leftSlantedRightRounded, slantOffset: 12.adapter)
                                        .fill(Color(red: 102 / 255, green: 72 / 255, blue: 255 / 255))
                                )
                        }.noClickEffect()
                    }
                    .padding(.vertical, 20.adapter)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                }
                .frame(maxHeight: .infinity).background(Color.white)
            }
        }.loginBg()
            .onAppear {
                viewModel.role = self.role
            }
        .overlay(
            Group {
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
        )
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(
                title: Text("提示"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("确定")) {
                    viewModel.errorMessage = nil
                }
            )
        }
        .onChange(of: viewModel.isSubmitSuccess) { success in
            if success {
                ScreenInfo.showSuccess("保存成功")
                // Return to home or pop view after successful submission
                AppRouter.shared.appRouter.popNavigation()
            }
        }.loginBg()
        .enableInjection()
    }

    // MARK: - Navigation Bar
    private var navigationBar: some View {
      HStack(spacing: 0) {
        LeadingBtn()

          Text(scoreStore.currentMatch?.eventName ?? "")
          .font(.system(size: 10.adapter, weight: .medium))
          .foregroundColor(Color(hex: "#FF222429"))

        Spacer()
        // Action buttons
        HStack(spacing: 12.adapter) {
          // Badminton button
          MyActionBtn(icon: "ball_01") {
              scoreStore.actionPlay()
          }

          // Pause button
            MyActionBtn(icon: "action_pause") {
                scoreStore.actionPause()
            }

          // Undo button
            MyActionBtn(icon: "action_cancel") {
                scoreStore.actionEnd()
            }

          // QR code button
            MyActionBtn(icon: "action_change") {
                scoreStore.actionChangeSwitch()
            }
        }
      }
      .padding(.trailing, 16.adapter)
    }
    


    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

// Helper for circular right icons
struct CircleActionIcon: View {
    let bgColor: Color
    let iconColor: Color
    let iconName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(bgColor)
                .frame(width: 32.adapter, height: 32.adapter)
            
            Image(systemName: iconName)
                .font(.system(size: 14.adapter))
                .foregroundColor(iconColor)
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct MatchSignatureView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(rootDestination: .matchSignature(role: "winner"))
    }
}
