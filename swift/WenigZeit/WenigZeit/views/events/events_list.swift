//
//  EventsList.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import SwiftUI
import EventKit

struct EventsList: View {
  @EnvironmentObject var context: Context
  @State private var prossecing = false
  @State private var refreshed_at: Date? = nil

  let timer = Timer.publish(every: 3600, tolerance: 900, on: .main, in: .common).autoconnect()

  var body: some View {
    NavigationView {
      ZStack {
        List {
          ForEach(context.events, id: \.self) { event in
            HStack {
              Text(event.title)
                .foregroundColor(eventColor(event))
              Spacer()
              VStack {
                Text(event.startDate, style: .time)
                Text(event.endDate, style: .time)
              }
            }
          }
        }

        if prossecing {
          ProgressView()
        }
      }
      .navigationTitle("Schedule")
      .navigationBarItems(
        trailing: Button("Refresh") {
          refresh()
        }
      )
      .onReceive(timer) { time in
        refresh()
      }
    }
  }

  func refresh() {
    if prossecing {
      return
    }
    prossecing = true
    context.refresh(true)
    refreshed_at = Date()
    prossecing = false
  }

  func eventColor(_ event:EKEvent) -> Color {
    if event.startDate < Date() {
      return Color.gray
    }

    if event.calendar != nil {
      return Color.init(event.calendar.cgColor)
    }

    return Color.yellow
  }
}

struct EventsList_Previews: PreviewProvider {
  static var previews: some View {
    EventsList()
      .environmentObject(Context())
      .previewLayout(.fixed(width: 300, height: 140))
  }
}
