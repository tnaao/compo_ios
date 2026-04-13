import SwiftUI

struct WarmupTimerExampleView: View {
    @State private var showWarmupTimer = false
    @State private var selectedTime: Int? = nil
    
    var body: some View {
        ZStack {
            // Your Main iPad App Interface
            VStack(spacing: 20) {
                Text("萧山区第六届羽毛球冠军赛")
                    .font(.largeTitle)
                    .padding()
                
                Button(action: {
                    withAnimation {
                        showWarmupTimer = true
                    }
                }) {
                    Text("显示热身计时弹窗")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if let time = selectedTime {
                    Text("选中的热身时间: \(time)分钟")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 242/255, green: 243/255, blue: 249/255))
            
            // Overlay the popup when triggered
            if showWarmupTimer {
                WarmupTimerPopupView(
                    contentView: EmptyView(),
                    onConfirm: { minutes in
                        // Handle the logic when user clicks confirm
                        selectedTime = minutes
                        withAnimation {
                            showWarmupTimer = false
                        }
                    },
                    onSkip: {
                        // Handle the logic when user clicks skip
                        withAnimation {
                            showWarmupTimer = false
                        }
                    }
                )
                // Ensures the popup stays on top of everything
                .zIndex(1)
            }
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct WarmupTimerExampleView_Previews: PreviewProvider {
    static var previews: some View {
        WarmupTimerExampleView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
