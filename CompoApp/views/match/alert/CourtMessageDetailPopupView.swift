import SwiftUI
import AdapterSwift

struct CourtMessageDetailPopupView: View {
    @Binding var isPresented: Bool
    var title: String = "场地消息"
    var message: AppBadmintonCourtMessageRespVO?
    var onDismiss: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Background Dim
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                    onDismiss?()
                }
            
            // Popup Container
            VStack(spacing: 0) {
                // Header with Gradient
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(hex: "#EBF5FF"),
                            Color(hex: "#F5EBFF"),
                            Color.white
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    Text(title)
                        .font(.system(size: 18.adapter, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(height: 60.adapter)
                .frame(maxWidth: .infinity)
                
                // Content
                VStack(spacing: 16.adapter) {
                    // Message Type Section
                    VStack(alignment: .leading, spacing: 8.adapter) {
                        Text("消息类型：")
                            .font(.system(size: 14.adapter))
                            .foregroundColor(Color(hex: "#999999"))
                        
                        Text(message?.messageType ?? "未知")
                            .font(.system(size: 16.adapter, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16.adapter)
                            .frame(height: 44.adapter)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#F5F7FA"))
                            .cornerRadius(8.adapter)
                    }
                    
                    // Message Content Section
                    VStack(alignment: .leading, spacing: 12.adapter) {
                        Text("消息内容：")
                            .font(.system(size: 18.adapter, weight: .bold))
                            .foregroundColor(Color(hex: "#6E5DFF"))
                        
                        ScrollView {
                            Text(message?.messageContent ?? "")
                                .font(.system(size: 16.adapter))
                                .foregroundColor(.black)
                                .lineSpacing(4.adapter)
                                .padding(12.adapter)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(minHeight: 140.adapter, maxHeight: 300.adapter)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8.adapter)
                                .stroke(Color(hex: "#DCDFE6"), lineWidth: 1.adapter)
                        )
                    }
                }
                .padding(24.adapter)
                
                // Confirm Button
                Button(action: {
                    isPresented = false
                    onDismiss?()
                }) {
                    Text("知道了")
                        .font(.system(size: 16.adapter, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 240.adapter, height: 44.adapter)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#7D60FF"), Color(hex: "#6E5DFF")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(Capsule())
                }
                .padding(.bottom, 24.adapter)
            }
            .frame(width: 417.adapter)
            .background(Color.white)
            .cornerRadius(16.adapter)
            .shadow(color: Color.black.opacity(0.1), radius: 10.adapter, x: 0, y: 5.adapter)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .enableInjection()
    }
    
    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}
