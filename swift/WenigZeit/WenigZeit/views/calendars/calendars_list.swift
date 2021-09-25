//
//  calendars_list.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import SwiftUI
import EventKit

struct CalendarsList: View {

  @EnvironmentObject var context: Context

  @State private var multiSelection = Set<UUID>()

  var body: some View {
    List(Calendar.calendars(context.event_store)) { calendar in
      HStack {
        Text(calendar.calendar.title)
          .foregroundColor(Color.init(calendar.calendar.cgColor))
        Spacer()
      }
    }
    .navigationTitle("Calendars")
  }
}

struct calendars_list_Previews: PreviewProvider {
  static var previews: some View {
    CalendarsList()
      .environmentObject(Context())
      .previewLayout(.fixed(width: 300, height: 170))
  }
}
