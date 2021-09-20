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
          prossecing = true
          context.refresh(true)
          prossecing = false
        }
      )
    }
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
