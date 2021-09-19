//
//  EventsList.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import SwiftUI

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
                .foregroundColor(Color.init(event.calendar.cgColor))
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
      .navigationTitle("Events")
      .navigationBarItems(
        trailing: Button("Refresh") {
          prossecing = true
          context.refresh()
          prossecing = false
        }
      )
    }
  }
}

struct EventsList_Previews: PreviewProvider {
  static var previews: some View {
    EventsList()
      .environmentObject(Context())
      .previewLayout(.fixed(width: 300, height: 140))
  }
}
