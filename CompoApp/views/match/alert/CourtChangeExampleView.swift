import SwiftUI
import AdapterSwift

struct CourtChangeExampleView: View {
    @State private var showPopup = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F5F6FA").ignoresSafeArea()
            
            VStack(spacing: 20.adapter) {
                Text("场地更换弹窗示例")
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
        .courtChangePopup(
            isPresented: $showPopup,
            oldCourt: "场地8",
            newCourt: "场地7",
            message: "场地8 第13场 小学E组男子单打 8进4[XEMS218]场地调整",
            onConfirm: {
                print("点击了知道了")
            }
        )
        .enableInjection()
    }
    
    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

@available(iOS 17.0, *)
#Preview(traits: .landscapeLeft) {
    CourtChangeExampleView()
}
