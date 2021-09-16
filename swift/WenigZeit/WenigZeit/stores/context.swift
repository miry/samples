//
//  context.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import Foundation
import EventKit

final class Context: ObservableObject {
  private let eventStore = EKEventStore()

  @Published var calendars: [EKCalendar] = []
  @Published var events: [EKEvent] = []
  @Published var workingHoursRange = 10..<22

  init() {
    request_access()
    calendars = fetch_calendars()
    events = fetch_events()
  }

  func request_access() {
    eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
      if !granted {
        fatalError("Couldn't grant access to calendars")
      }
    })
  }

  func fetch_calendars() -> [EKCalendar] {
    var result: [EKCalendar] = []

    for calendar in eventStore.calendars(for: EKEntityType.event) {
      print(calendar)
      print(calendar.source)
      print(calendar.isSubscribed)
      print(calendar.isImmutable)
      if calendar.allowsContentModifications {
        result.append(calendar)
      }
    }
    return result
  }


  func fetch_events() -> [EKEvent] {
    var result : [EKEvent] = []
    let today = Date()
    var previous = today ... today

    let now = NSDate(timeIntervalSinceNow: 0)
    let oneday = NSDate(timeIntervalSinceNow: +24*3600)

    let predicate = eventStore.predicateForEvents(
      withStart: now as Date,
      end: oneday as Date,
      calendars: calendars)
    let events = eventStore.events(matching: predicate)

    for event in events {
      if event.isAllDay ||
          event.status != EKEventStatus.confirmed ||
          event.availability != EKEventAvailability.busy {
        print("skipped event: ", String(event.title))
        continue
      }

      print("Checking working hours range")
      let eventStartHour = Calendar.current.component(.hour, from: event.startDate)
      if !workingHoursRange.contains(eventStartHour) {
        print("skipped event: ", String(event.title))
        continue
      }

      print("Check for duplication")
      if previous.contains(event.startDate) {
        if !previous.contains(event.endDate) {
          previous = previous.lowerBound ... event.endDate
          result.append(event)
        } else {
          print("skipped event: ", String(event.title))
        }
      } else {
        result.append(event)
        previous = event.startDate ... event.endDate
      }
    }
    return result
  }
}
