//
//  EventsList.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import SwiftUI

struct EventsList: View {
  @EnvironmentObject var context: Context

  var body: some View {
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
  }
}

struct EventsList_Previews: PreviewProvider {
  static var previews: some View {
    EventsList()
      .environmentObject(Context())
      .previewLayout(.fixed(width: 300, height: 140))
  }
}
