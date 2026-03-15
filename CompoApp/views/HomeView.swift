//
//  HomeView.swift
//  CompoApp
//
//  Created by GH w on 3/15/26.
//

import SwiftUI

struct HomeView: View {
  let rootPath: Binding<[Destination]> = .constant([])
  @State private var petName = "当前萌宠名称"
  @State private var batteryLevel = 50
  @State private var voiceLevel = 80
  @State private var speechRate = "均衡"

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Background gradient
        LinearGradient(
          colors: [
            Color(red: 1.0, green: 0.85, blue: 0.8),
            Color(red: 1.0, green: 0.75, blue: 0.7),
          ],
          startPoint: .top,
          endPoint: .bottom
        )
        .ignoresSafeArea()

        VStack(spacing: 0) {
          // Header
          headerView

          // Pet character area
          petCharacterView
            .frame(maxHeight: .infinity)

          // Status cards
          statusCardsView
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

          // Feature cards grid
          featureCardsView
            .padding(.horizontal, 16)
            .padding(.bottom, 33)
          Spacer().frame(height: 50)
        }
      }
    }
  }

  // MARK: - Header
  private var headerView: some View {
    HStack {
      // Pet name with edit button
      HStack(spacing: 8) {
        Text(petName)
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(.black)

        Image(systemName: "pencil")
          .font(.system(size: 16))
          .foregroundColor(.black)
      }

      Spacer()

      // Control buttons
      HStack(spacing: 12) {
        // WiFi button
        Button(action: {}) {
          Image(systemName: "wifi")
            .font(.system(size: 18))
            .foregroundColor(.yellow)
            .frame(width: 36, height: 36)
            .background(Color.black.opacity(0.3))
            .clipShape(Circle())
        }

        // Power button
        Button(action: {}) {
          HStack(spacing: 4) {
            Image(systemName: "power")
              .font(.system(size: 14))
            Text("关机")
              .font(.system(size: 12))
          }
          .foregroundColor(.white)
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(Color.red.opacity(0.8))
          .clipShape(Capsule())
        }

        // Settings button
        Button(action: {}) {
          Image(systemName: "gearshape.fill")
            .font(.system(size: 18))
            .foregroundColor(.white)
            .frame(width: 36, height: 36)
            .background(Color.black.opacity(0.3))
            .clipShape(Circle())
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 8)
  }

  // MARK: - Pet Character
  private var petCharacterView: some View {
    ZStack {
      // Placeholder for 3D pet character
      Circle()
        .fill(Color.white.opacity(0.3))
        .frame(width: 200, height: 200)

      Image(systemName: "teddybear.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 120, height: 120)
        .foregroundColor(.brown.opacity(0.6))
    }
  }

  // MARK: - Status Cards
  private var statusCardsView: some View {
    HStack(spacing: 12) {
      // Battery status
      StatusCard(
        value: "\(batteryLevel)%",
        label: "电量",
        icon: "battery.50",
        color: Color(red: 0.9, green: 0.5, blue: 0.5)
      )

      // Voice status
      StatusCard(
        value: "\(voiceLevel)%",
        label: "声音",
        icon: "speaker.wave.2.fill",
        color: Color(red: 0.9, green: 0.7, blue: 0.3)
      )

      // Speech rate status
      StatusCard(
        value: speechRate,
        label: "语速",
        icon: "waveform",
        color: Color(red: 0.3, green: 0.7, blue: 0.5)
      )
    }
  }

  // MARK: - Feature Cards
  private var featureCardsView: some View {
    VStack(spacing: 12) {
      HStack(spacing: 12) {
        FeatureCard(
          title: "音色切换",
          subtitle: "人声·俏皮女生",
          icon: "music.note",
          iconColor: .purple,
          backgroundColor: Color(red: 0.85, green: 0.85, blue: 1.0)
        )

        FeatureCard(
          title: "角色切换",
          subtitle: "当前萌宠名称",
          icon: "teddybear.fill",
          iconColor: .pink,
          backgroundColor: Color(red: 1.0, green: 0.85, blue: 0.9)
        )
      }

      HStack(spacing: 12) {
        FeatureCard(
          title: "性格养成",
          subtitle: "待后台上传后",
          icon: "star.fill",
          iconColor: .orange,
          backgroundColor: Color(red: 1.0, green: 0.95, blue: 0.8)
        )

        FeatureCard(
          title: "成长奖励",
          subtitle: "亲密度悄悄升温",
          icon: "leaf.fill",
          iconColor: .green,
          backgroundColor: Color(red: 0.8, green: 1.0, blue: 0.9)
        )
      }
    }
  }
}

// MARK: - Status Card
struct StatusCard: View {
  let value: String
  let label: String
  let icon: String
  let color: Color

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(value)
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(.white)

        Text(label)
          .font(.system(size: 12))
          .foregroundColor(.white.opacity(0.9))
      }

      Spacer()

      Image(systemName: icon)
        .font(.system(size: 20))
        .foregroundColor(.white)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .background(color)
    .cornerRadius(16)
  }
}

// MARK: - Feature Card
struct FeatureCard: View {
  let title: String
  let subtitle: String
  let icon: String
  let iconColor: Color
  let backgroundColor: Color

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(.black)

        Text(subtitle)
          .font(.system(size: 12))
          .foregroundColor(.gray)

        HStack(spacing: 2) {
          Image(systemName: "play.fill")
            .font(.system(size: 8))
          Image(systemName: "play.fill")
            .font(.system(size: 8))
          Image(systemName: "play.fill")
            .font(.system(size: 8))
        }
        .foregroundColor(.purple)
        .padding(.top, 4)
      }

      Spacer()

      Image(systemName: icon)
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
        .foregroundColor(iconColor)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 12)
    .background(backgroundColor)
    .cornerRadius(16)
  }
}

#Preview {
  HomeView()
}
