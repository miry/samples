//
//  calendar.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 25.09.21.
//

import EventKit
import SwiftUI

struct Calendar: Identifiable, Hashable {
  let calendar: EKCalendar
  var id: String
  var title: String
  var color: Color

  init(calendar: EKCalendar) {
    self.calendar = calendar
    self.id = calendar.calendarIdentifier
    self.title = calendar.title
    self.color = Color.init(calendar.cgColor)
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
