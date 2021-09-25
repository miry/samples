//
//  calendar.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 25.09.21.
//

import EventKit

struct Calendar: Identifiable, Hashable {
  let calendar: EKCalendar
  var id: String {
    calendar.calendarIdentifier
  }

  static func calendars(_ event_store:EKEventStore) -> [Calendar] {
    var result: [Calendar] = []

    for calendar in event_store.calendars(for: EKEntityType.event) {
      if calendar.allowsContentModifications {
        result.append(Calendar(calendar: calendar))
      }
    }
    return result
  }
}
