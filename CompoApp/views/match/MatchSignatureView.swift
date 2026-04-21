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

struct MatchSignatureView: View {
    var placeholderName: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State private var lines = [[CGPoint]]()
    @StateObject private var scoreStore: MatchScoringStore = MatchScoringStore.shared
    @StateObject private var viewModel = MatchSignatureVm()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top Navigation Bar
                HStack(spacing: 0.adapter) {
                    // Back Button
                    LeadingBtn()
                    
                    Text(scoreStore.currentMatch?.eventName ?? "")
                        .font(.system(size: 16.adapter, weight: .regular))
                        .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                    
                    Spacer()
                    
                    // Right Action Icons
                    HStack(spacing: 16.adapter) {
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
                        
                        // Swap button
                          MyActionBtn(icon: "action_change") {
                              scoreStore.actionChangeSwitch()

                          }
                    }
                }
                .frame(height: 40.adapter)
                .padding(.trailing, 20.adapter)
                
                // Signature Area
                ZStack {
                    Color.white
                    
                    VStack {
                        HStack {
                            Text("胜方签名")
                                .font(.system(size: 14.adapter, weight: .regular))
                                .foregroundColor(Color(red: 102 / 255, green: 102 / 255, blue: 102 / 255))
                                .padding(.leading, 20.adapter)
                                .padding(.top, 20.adapter)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    Text(placeholderName)
                        .font(.system(size: 20.adapter, weight: .regular))
                        .foregroundColor(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255)) // Very faint gray
                    
                    SignaturePadView(lines: $lines)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Bottom Action Area
                HStack(spacing: 8.adapter) {
                    // Clear Button
                    Button(action: {
                        lines.removeAll()
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
                            .frame(width: 400.adapter, height: 200.adapter)
                        viewModel.saveSignature(signatureView: signatureView, matchNo: matchNo)
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
                        presentationMode.wrappedValue.dismiss()
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
            .frame(maxHeight: .infinity)
        }.loginBg()
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
        }
        .enableInjection()
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
        RootView(rootDestination: .matchSignature)
    }
}
