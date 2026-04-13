import SwiftUI
import AdapterSwift

struct MessageNotificationPopupView: View {
    @Binding var isPresented: Bool
    var title: String = "消息通知"
    @State var selectedReason: String = "弃权"
    @State private var isDropdownExpanded: Bool = false
    var messageContent: String = "场地8 第13场 小学E组男子单打 8进4[XEMS218]场地调整，选手王吴苇航【原创体育】已经到场。当前得分0.0。场地裁判:张三|"
    var onConfirm: (() -> Void)?
    
    let reasonOptions = ["到场", "弃权", "受伤", "暂停"]
    
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
                VStack(spacing: 16.adapter) {
                    // Reason Dropdown/Selection
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isDropdownExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text(selectedReason)
                                .font(.system(size: 16.adapter))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 14.adapter))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16.adapter)
                        .frame(height: 44.adapter)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8.adapter)
                                .stroke(Color(hex: "#DCDFE6"), lineWidth: 1.adapter)
                        )
                    }
                    .overlay(
                        Group {
                            if isDropdownExpanded {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("消息类型")
                                        .font(.system(size: 14.adapter))
                                        .foregroundColor(Color(hex: "#999999"))
                                        .padding(.horizontal, 16.adapter)
                                        .padding(.vertical, 12.adapter)
                                    
                                    Divider()
                                    
                                    ForEach(reasonOptions, id: \.self) { option in
                                        Button(action: {
                                            selectedReason = option
                                            withAnimation(.easeInOut(duration: 0.15)) {
                                                isDropdownExpanded = false
                                            }
                                        }) {
                                            HStack {
                                                Text(option)
                                                    .font(.system(size: 16.adapter))
                                                    .foregroundColor(selectedReason == option ? Color(hex: "#6E5DFF") : .black)
                                                Spacer()
                                                if selectedReason == option {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(Color(hex: "#6E5DFF"))
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16.adapter)
                                        .frame(height: 44.adapter)
                                        .background(selectedReason == option ? Color(hex: "#F5F3FF") : Color.white)
                                    }
                                }
                                .frame(width: 160.adapter)
                                .background(Color.white)
                                .cornerRadius(8.adapter)
                                .shadow(color: Color.black.opacity(0.12), radius: 8.adapter, x: 0, y: 4.adapter)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8.adapter)
                                        .stroke(Color(hex: "#EEEEEE"), lineWidth: 1.adapter)
                                )
                                .offset(y: 48.adapter)
                            }
                        },
                        alignment: .topLeading
                    )
                    .zIndex(2)
                    
                    // Message Content Section
                    VStack(alignment: .leading, spacing: 12.adapter) {
                        Text("消息内容：")
                            .font(.system(size: 18.adapter, weight: .bold))
                            .foregroundColor(Color(hex: "#6E5DFF"))
                        
                        Text(messageContent)
                            .font(.system(size: 16.adapter))
                            .foregroundColor(.black)
                            .lineSpacing(4.adapter)
                            .padding(12.adapter)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 140.adapter, alignment: .topLeading)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8.adapter)
                                    .stroke(Color(hex: "#DCDFE6"), lineWidth: 1.adapter)
                            )
                    }
                    .zIndex(1)
                }
                .padding(24.adapter)
                .zIndex(1)
                
                // Confirm Button
                Button(action: {
                    onConfirm?()
                    isPresented = false
                }) {
                    Text("确定")
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

#Preview {
    MessageNotificationPopupView(isPresented: .constant(true))
        .previewInterfaceOrientation(.landscapeLeft)
}
