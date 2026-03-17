//
//  GameOnGoingListView.swift
//  CompoApp
//
//  Created by Qoder on 3/17/26.
//

import SwiftUI
import AdapterSwift
import AppRouter

struct GameOnGoingListView: View {
  let matches = [
    MatchModel(
      title: "2025年VICTOR萧山区第六届青少年羽毛球冠军赛1",
      dateTime: "2025-12-20 9:00至18:00",
      location: "杭州市萧山区体育馆",
      status: .ongoing,
      imageName: "match_badminton_1"
    ),
    MatchModel(
      title: "2025年VICTOR萧山区第六届青少年羽毛球冠军赛2",
      dateTime: "2025-12-20 9:00至18:00",
      location: "杭州市萧山区体育馆",
      status: .completed,
      imageName: "match_badminton_2"
    ),
  ]

  @Environment(SimpleRouter<Destination, Sheet>.self) private var router
  var body: some View {

    ScrollView {
        LazyVStack(spacing: 12.adapter) {
        ForEach(matches) { match in
            Button {
                router.navigateTo(.gamedetailHome)
            } label: {
                GameCard(match: match)
            }

        }
      }
        .padding(EdgeInsets(top: 17.adapter, leading: 12.adapter, bottom: 0, trailing: 12.adapter))
    }
  }
}

// MARK: - Game Card
struct GameCard: View {
  let match: MatchModel

  var body: some View {
    HStack(spacing: 16) {
      // Image with status badge
      ZStack(alignment: .topLeading) {
        MyNetImage(url:"",width: 140,height: 90,radius: 7)
          
        // Status badge
        Text(match.status.title)
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(.white)
          .padding(.horizontal, 10)
          .padding(.vertical, 6)
          .background(match.status.backgroundColor)
          .cornerRadius(7, corners: [.topLeft, .bottomRight])
      }

      // Content
      VStack(alignment: .leading, spacing: 12) {
        Text(match.title)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
          .lineLimit(2)

        // Date & Time
        HStack(spacing: 6) {
          Image(systemName: "clock")
            .font(.system(size: 14))
            .foregroundColor(Color.gray)

          Text(match.dateTime)
            .font(.system(size: 14))
            .foregroundColor(Color.gray)
        }

        // Location
        HStack(spacing: 6) {
          Image(systemName: "mappin.circle")
            .font(.system(size: 14))
            .foregroundColor(Color.gray)

          Text(match.location)
            .font(.system(size: 14))
            .foregroundColor(Color.gray)
        }
      }

      Spacer()
    }
    .padding(16)
    .background(Color.white)
    .cornerRadius(9)
  }
}

#Preview {
    ContentView()
}
