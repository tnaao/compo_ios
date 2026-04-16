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

  @Environment(\.appRouter) private var router
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
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

// MARK: - Game Card
struct GameCard: View {
  let match: MatchModel

  var body: some View {
      HStack(spacing: 16.adapter) {
      // Image with status badge
      ZStack(alignment: .topLeading) {
          MyNetImage(url:nil,width: 145.adapter,height: 90.adapter,radius: 7.adapter)
          
        // Status badge
        Text(match.status.title)
              .font(.system(size: 12.adapter, weight: .medium))
          .foregroundColor(.white)
          .padding(.horizontal, 10.adapter)
          .padding(.vertical, 6.verticaldapter)
          .background(match.status.backgroundColor)
          .cornerRadius(7.adapter, corners: [.topLeft, .bottomRight])
      }

      // Content
          VStack(alignment: .leading, spacing: 12.verticaldapter) {
        Text(match.title)
                  .font(.system(size: 16.adapter, weight: .bold))
          .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
          .lineLimit(2)
          .multilineTextAlignment(.leading)

        // Date & Time
              HStack(spacing: 6.adapter) {
          Image(systemName: "clock")
                      .font(.system(size: 14.adapter))
            .foregroundColor(Color.gray)

          Text(match.dateTime)
                      .font(.system(size: 14.adapter))
            .foregroundColor(Color.gray)
        }

        // Location
              HStack(spacing: 6.adapter) {
          Image(systemName: "mappin.circle")
                      .font(.system(size: 14.adapter))
            .foregroundColor(Color.gray)

          Text(match.location)
                      .font(.system(size: 14.adapter))
            .foregroundColor(Color.gray)
        }
      }

      Spacer()
    }
    .padding(.horizontal,16.adapter)
    .frame(height: 120.adapter)
    .background(Color.white)
    .cornerRadius(9.adapter)
    
      .enableInjection()
  }

  #if DEBUG
  @ObserveInjection var forceRedraw
  #endif
}

#Preview {
    RootView()
}
