import SwiftUI
import AdapterSwift

struct CourtChangePopupView: View {
    @Binding var isPresented: Bool
    var title: String = "场地更换通知"
    var oldCourt: String = "场地8"
    var newCourt: String = "场地7"
    var messageContent: String = "场地8 第13场 小学E组男子单打 8进4[XEMS218]场地调整"
    var onConfirm: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Background Dim
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
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
                VStack(spacing: 24.adapter) {
                    
                    // Court Change Indicator
                    HStack(spacing: 16.adapter) {
                        Text(oldCourt)
                            .font(.system(size: 24.adapter, weight: .bold))
                            .foregroundColor(Color(hex: "#6E5DFF"))
                        
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#6E5DFF"))
                                .frame(width: 28.adapter, height: 28.adapter)
                            Text("换")
                                .font(.system(size: 14.adapter, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Text(newCourt)
                            .font(.system(size: 24.adapter, weight: .bold))
                            .foregroundColor(Color(hex: "#6E5DFF"))
                    }
                    .padding(.top, 20.adapter)
                    
                    // Message
                    Text(messageContent)
                        .font(.system(size: 16.adapter))
                        .foregroundColor(Color(hex: "#333333"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24.adapter)
                }
                .padding(.bottom, 32.adapter)
                
                // Confirm Button
                Button(action: {
                    onConfirm?()
                    isPresented = false
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
                .padding(.bottom, 32.adapter)
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

@available(iOS 17.0, *)
#Preview(traits: .landscapeLeft) {
    CourtChangePopupView(isPresented: .constant(true))
}
