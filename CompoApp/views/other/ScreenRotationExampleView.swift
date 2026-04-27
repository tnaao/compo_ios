//
//  ScreenRotationExampleView.swift
//  CompoApp
//
//  Created by GH w on 3/28/26.
//

import SwiftUI

struct ScreenRotationExampleView: View {
  @StateObject private var screenInfo = ScreenInfo.shared

  var body: some View {
    VStack(spacing: 20) {
      Text("Screen Rotation Example")
        .font(.largeTitle)
        .fontWeight(.bold)

      Text("Current Orientation: \(orientationText)")
        .font(.title2)
        .foregroundColor(.primary)

      Text("Screen Size: \(Int(screenInfo.width)) × \(Int(screenInfo.height))")
        .font(.title3)
        .foregroundColor(.secondary)

      if screenInfo.isLandscape {
        Text("Device is in Landscape mode")
          .font(.headline)
          .foregroundColor(.green)
      } else if screenInfo.isPortrait {
        Text("Device is in Portrait mode")
          .font(.headline)
          .foregroundColor(.blue)
      } else {
        Text("Unknown orientation")
          .font(.headline)
          .foregroundColor(.gray)
      }

      Spacer()

      // Example of layout that adapts to orientation
      HStack(spacing: 20) {
        if screenInfo.isLandscape {
          // Landscape layout - side by side
          Color.red
            .frame(height: 200)
            .cornerRadius(10)
          Color.blue
            .frame(height: 200)
            .cornerRadius(10)
        } else {
          // Portrait layout - stacked
          Color.red
            .frame(height: 150)
            .cornerRadius(10)
          Color.blue
            .frame(height: 150)
            .cornerRadius(10)
        }
      }
      .padding()
    }
    .padding()
    .navigationTitle("Screen Rotation")
  }

  private var orientationText: String {
    switch screenInfo.orientation {
    case .portrait:
      return "Portrait"
    case .portraitUpsideDown:
      return "Portrait Upside Down"
    case .landscapeLeft:
      return "Landscape Left"
    case .landscapeRight:
      return "Landscape Right"
    case .faceUp:
      return "Face Up"
    case .faceDown:
      return "Face Down"
    default:
      return "Unknown"
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  ScreenRotationExampleView()
}
