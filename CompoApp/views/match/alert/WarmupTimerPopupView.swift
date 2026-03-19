import AdapterSwift
import SwiftUI

struct WarmupTimerPopupView<Content: View>: View {
  var contentView: Content = EmptyView() as! Content
  // Callbacks to handle actions from the popup
  var onConfirm: ((Int) -> Void)?
  var onSkip: (() -> Void)?
  var isCustomContent: Bool = false
  var padddingBottomNum: CGFloat = 20
  // Timer selection state
  @State private var selectedMinutes: Int = 1

  // Match data (can be injected via a model)
  let courtName = "场地8"
  let team1Name = "原创体育"
  let team1SetPoints = 0
  let team1Player = "余苇航"
  let team1Points = 0
  let team1IsServing = true

  let matchNumber = "第13场"
  let team2Name = "萧山羽飞"
  let team2SetPoints = 0
  let team2Player = "郑泽言"
  let team2Points = 0
  let team2IsServing = false

  var body: some View {
    ZStack {
      // Dark Overlay background
      Color.black.opacity(0.4)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
          onSkip?()
        }

      // Modal Container - 417x300 proportion
      VStack(spacing: 0) {

        // Top Match Info Section (Gradient Background)
        VStack(spacing: 8.adapter) {
          // Row 1
          HStack(spacing: 8.adapter) {
            // Team 1 Label
            HStack {
              Text(courtName)
                .font(.system(size: 11.adapter))
                .foregroundColor(.white)
                .opacity(0.9)
              Spacer(minLength: 4.adapter)
              Text(team1Name)
                .font(.system(size: 11.adapter))
                .foregroundColor(.white)
            }
            .padding(.horizontal, 10.adapter)
            .frame(width: 110.adapter, height: 26.adapter)
            .background(Color(red: 126 / 255, green: 96 / 255, blue: 254 / 255))
            .cornerRadius(4.adapter)

            // Sets
            Text("\(team1SetPoints)")
              .font(.system(size: 14.adapter, weight: .bold))
              .foregroundColor(Color(red: 255 / 255, green: 65 / 255, blue: 55 / 255))
              .frame(width: 14.adapter)

            // Player 1
            Text(team1Player)
              .font(.system(size: 11.adapter))
              .foregroundColor(.white)
              .frame(width: 60.adapter, height: 26.adapter)
              .background(Color(red: 126 / 255, green: 96 / 255, blue: 254 / 255))
              .cornerRadius(4.adapter)

            // Points
            Text(String(format: "%02d", team1Points))
              .font(.system(size: 14.adapter, weight: .bold))
              .foregroundColor(.black)
              .frame(width: 20.adapter)
          }

          // Row 2
          HStack(spacing: 8.adapter) {
            // Team 2 Label
            HStack {
              Text(matchNumber)
                .font(.system(size: 11.adapter))
                .foregroundColor(.white)
                .opacity(0.9)
              Spacer(minLength: 4.adapter)
              Text(team2Name)
                .font(.system(size: 11.adapter))
                .foregroundColor(.white)
            }
            .padding(.horizontal, 10.adapter)
            .frame(width: 110.adapter, height: 26.adapter)
            .background(Color(red: 126 / 255, green: 96 / 255, blue: 254 / 255))
            .cornerRadius(4.adapter)

            // Sets
            Text("\(team2SetPoints)")
              .font(.system(size: 14.adapter, weight: .bold))
              .foregroundColor(Color(red: 255 / 255, green: 65 / 255, blue: 55 / 255))
              .frame(width: 14.adapter)

            // Player 2
            Text(team2Player)
              .font(.system(size: 11.adapter))
              .foregroundColor(.white)
              .frame(width: 60.adapter, height: 26.adapter)
              .background(Color(red: 126 / 255, green: 96 / 255, blue: 254 / 255))
              .cornerRadius(4.adapter)

            // Points
            Text(String(format: "%02d", team2Points))
              .font(.system(size: 14.adapter, weight: .bold))
              .foregroundColor(.black)
              .frame(width: 20.adapter)
          }
        }
        .padding(.vertical, 20.adapter)
        .frame(maxWidth: .infinity)
        .background(
          LinearGradient(
            colors: [
              Color(red: 235 / 255, green: 245 / 255, blue: 255 / 255),
              Color(red: 245 / 255, green: 235 / 255, blue: 255 / 255),
              Color(red: 255 / 255, green: 240 / 255, blue: 240 / 255),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )

        // Bottom Timer Section (White Background)
        ZStack(alignment: .center) {
          VStack {
            Spacer()
            Text("")
          }
          contentView.xVisible(isCustomContent)
          VStack {
            //计时器内容
            VStack(spacing: 0) {
              Text("热身计时")
                .font(.system(size: 20.adapter, weight: .bold))
                .foregroundColor(.black)

              Spacer().fixedSize().frame(height: 20.adapter)
              // Timer Selectors buttons
              TimerSelectorView(
                options: [
                  TimerOption(
                    title: "1分钟", color: Color(red: 0 / 255, green: 200 / 255, blue: 224 / 255),
                    value: 1),
                  TimerOption(
                    title: "2分钟", color: Color(red: 90 / 255, green: 115 / 255, blue: 255 / 255),
                    value: 2),
                  TimerOption(
                    title: "5分钟", color: Color(red: 16 / 255, green: 195 / 255, blue: 75 / 255),
                    value: 5),
                  TimerOption(
                    title: "10分钟", color: Color(red: 255 / 255, green: 140 / 255, blue: 34 / 255),
                    value: 10),
                ],
                selectedValue: $selectedMinutes
              )
            }
          }.xVisible(!isCustomContent)

        }
        .frame(maxWidth: .infinity)

        // Sticky Bottom Buttons
        HStack(spacing: 0) {
          Button(action: {
            onSkip?()
          }) {
            Text("跳过")
              .font(.system(size: 14.adapter, weight: .medium))
              .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }

          Button(action: {
            onConfirm?(selectedMinutes)
          }) {
            Text("确认")
              .font(.system(size: 14.adapter, weight: .medium))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
        .frame(width: 180.adapter, height: 36.adapter)
        .background(content: {
          HStack {
            Spacer().bgImage("alert_btn_bg_s1").offset(x: 4.adapter)
            Spacer().bgImage("alert_btn_bg_s2").offset(x: -4.adapter)
          }
        })
        .clipShape(Capsule())
        .padding(.bottom, padddingBottomNum.adapter)
      }
      .frame(width: 417.adapter)  // Requested strict width
      .frame(maxHeight: 300.adapter)
      .background(
        Color.white
      ).cornerRadius(14.adapter)

    }
    .transition(.opacity.combined(with: .scale(scale: 0.95)))
  }
}

// MARK: - Scaled Reusable Timers Button
struct TimerOptionButton: View {
  let title: String
  let color: Color
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: 15.adapter, weight: .medium))
        .foregroundColor(.white)
        .frame(width: 74.adapter, height: 50.adapter)
        .background(color)
        .cornerRadius(8.adapter)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black.opacity(isSelected ? 0.3 : 0), lineWidth: 2.adapter)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
  }
}

// MARK: - Scaled Handcrafted Shuttlecock Icon Badge
struct ServerBadgeView: View {
  var body: some View {
    ZStack {
      // Circle Badge Backing Red
      Circle()
        .fill(Color(red: 255 / 255, green: 80 / 255, blue: 70 / 255))

      // Faux Shuttle Cock
      Image(systemName: "wifi")
        .font(.system(size: 8.adapter, weight: .heavy))
        .foregroundColor(.white)
        .rotationEffect(.degrees(180))
        .offset(y: -1.adapter)

      Circle()
        .fill(Color.white)
        .frame(width: 3.adapter, height: 3.adapter)
        .offset(y: 3.adapter)
    }
    .rotationEffect(.degrees(30))
  }
}

// MARK: - Timer Option Model
struct TimerOption: Identifiable {
  let id = UUID()
  let title: String
  let color: Color
  let value: Int
}

// MARK: - Timer Selector View
struct TimerSelectorView: View {
  let options: [TimerOption]
  @Binding var selectedValue: Int

  var body: some View {
    HStack(spacing: 12.adapter) {
      ForEach(options) { option in
        TimerOptionButton(
          title: option.title,
          color: option.color,
          isSelected: selectedValue == option.value,
          action: { selectedValue = option.value }
        )
      }
    }
  }
}

struct WarmupTimerPopupView_Previews: PreviewProvider {
  static var previews: some View {
    WarmupTimerPopupView(contentView: Text("hello"))
      .previewInterfaceOrientation(.landscapeLeft)
  }
}
