import SwiftUI
import AdapterSwift

struct MessageNotificationExampleView: View {
    @State private var showPopup = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F5F6FA").ignoresSafeArea()
            
            VStack(spacing: 20.adapter) {
                Text("消息通知弹窗示例")
                    .font(.system(size: 24.adapter, weight: .bold))
                
                Button(action: {
                    showPopup = true
                }) {
                    Text("显示弹窗")
                        .font(.system(size: 16.adapter, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32.adapter)
                        .padding(.vertical, 12.adapter)
                        .background(Color(hex: "#6E5DFF"))
                        .cornerRadius(8.adapter)
                }
            }
        }
        // 使用扩展方法调用弹窗
        .messageNotificationPopup(
            isPresented: $showPopup,
            reason: "弃权",
            content: "场地8 第13场 小学groupE组男子单打 8进4[XEMS218]场地调整，选手王吴苇航【原创体育】已经到场。当前得分0.0。场地裁判:张三",
            onConfirm: {
                print("点击了确定")
            }
        )
        .enableInjection()
    }
    
    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

#Preview {
    MessageNotificationExampleView()
        .previewInterfaceOrientation(.landscapeLeft)
}
