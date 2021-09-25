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

  var body: some View {
    List(context.available_calendars, selection: $context.selected_calendars) { calendar in
      Text(calendar.title)
        .foregroundColor(calendar.color)
    }
    .environment(\.editMode, .constant(EditMode.active))
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
