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
  @Published var reminders: [Date] = []
  @Published var working_mins : Int = 30
  @Published var relaxing_mins : Int = 5
  @Published var routines: [String] = [
    "Read book",
    "Workout",
    "Push ups",
    "Review daily tasks"
  ]

  init() {
    request_access()
    refresh()
  }

  func refresh() {
    calendars = fetch_calendars()
    events = fetch_events()
    reminders = plan_routines_reminders()

    events.sort {
      $0.startDate < $1.startDate
    }
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

  // Build a timetable for routines
  func plan_routines_reminders() -> [Date] {
    if events.count <= 1 {
      return []
    }

    var prev : EKEvent = events[0]
    var result : [Date] = []

    let working_duration = DateComponents(calendar: Calendar.current, minute: working_mins)
    let relaxing_duration = DateComponents(calendar: Calendar.current, minute: relaxing_mins)

    for event in events[1 ... events.count - 1] {
      var duration_min : Int = Int(event.startDate.timeIntervalSinceReferenceDate - prev.endDate.timeIntervalSinceReferenceDate) / 60
      print("duration between: \(event.title) and \(prev.title)", duration_min)

      if duration_min > 0 {
        if duration_min <= working_mins {
          add_event("Work \(duration_min) min", prev.endDate, event.startDate)
        } else {
          var event_started_at = prev.endDate!
          var event_ended_at = event_started_at
          while duration_min > 0 {
            if duration_min > working_mins {
              event_ended_at = Calendar.current.date(byAdding: working_duration, to: event_started_at)!
              add_event("Work \(working_mins) min", event_started_at, event_ended_at)
              duration_min = duration_min - working_mins
              event_started_at = event_ended_at
            } else {
              add_event("Work \(duration_min) min", event_started_at, event.startDate)
              duration_min = 0
            }

            if duration_min <= 0 {
              break
            }

            result.append(event_started_at)
            if duration_min > relaxing_mins {
              event_ended_at = Calendar.current.date(byAdding: relaxing_duration, to: event_started_at)!
              add_event("Relax \(relaxing_mins) min", event_started_at, event_ended_at)
              duration_min = duration_min - relaxing_mins
            } else {
              add_event("Relax \(duration_min) min", event_started_at, event.startDate)
              duration_min = 0
            }
          }
        }
      }

      prev = event
    }



    return result
  }

  func add_event(_ title:String, _ start:Date, _ end:Date) {
    let reserver:EKEvent = EKEvent(eventStore: eventStore)
    reserver.title = title
    reserver.startDate = start
    reserver.endDate = end
    reserver.calendar = eventStore.defaultCalendarForNewEvents
    events.append(reserver)
  }
}
