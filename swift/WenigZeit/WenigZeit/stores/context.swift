//
//  context.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import Foundation
import EventKit
import UserNotifications

final class Context: ObservableObject {
  private let eventStore = EKEventStore()
  private let center = UNUserNotificationCenter.current()

  @Published var calendars: [EKCalendar] = []
  @Published var events: [EKEvent] = []
  @Published var workingHoursRange = 10..<22
  @Published var working_mins : Int = 30
  @Published var relaxing_mins : Int = 5
  @Published var routines: [String] = [
    "Read book",
    "Workout",
    "Push ups",
    "Review daily tasks",
    "Running"
  ]

  init() {
    request_access()
    refresh()
  }

  func refresh() {
    print("refresh data invoked")
    calendars = fetch_calendars()
    events = fetch_events()
    let reminders = plan_routines_reminders()
    events.sort {
      $0.startDate < $1.startDate
    }

    for reminder in reminders {
      schedule_reminder(reminder)
    }
  }

  func request_access() {
    eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
      if !granted {
        fatalError("Couldn't grant access to calendars")
      }
    })

    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if !granted {
        fatalError("Couldn't grant access to notifications")
      }
    }
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

    let now = Date()
    let oneday = NSDate(timeIntervalSinceNow: +24*3600)

    //    Identify the start of the events today at 10 hours or tomorrow at 10 hours
    //    If it is already late, then show plan for tomorrow
    var components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: now)
    if components.hour! > workingHoursRange.upperBound {
      components.day = components.day! + 1
    }
    components.hour = workingHoursRange.lowerBound
    components.minute = 0
    let start_working_hours = Calendar.current.date(from: components)
    print("start_working_hours:", start_working_hours)
    //    end of calculating the day

    let predicate = eventStore.predicateForEvents(
      withStart: start_working_hours!,
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
        //        print("skipped event: ", String(event.title))
        continue
      }

      print("Check for duplication")
      if previous.contains(event.startDate) {
        if !previous.contains(event.endDate) {
          previous = previous.lowerBound ... event.endDate
          result.append(event)
        } else {
          //          print("skipped event: ", String(event.title))
        }
      } else {
        result.append(event)
        previous = event.startDate ... event.endDate
      }
    }
    return result
  }

  struct Reminder: Hashable, Identifiable {
    var id: String
    var title: String
    var date: DateComponents
  }
  
  // Build a timetable for routines
  func plan_routines_reminders() -> [Reminder] {
    if events.count <= 1 {
      return []
    }

    var prev : EKEvent = events[0]
    var result : [Reminder] = []

    let working_duration = DateComponents(calendar: Calendar.current, minute: working_mins)
    let relaxing_duration = DateComponents(calendar: Calendar.current, minute: relaxing_mins)

    // Set upper boudnries
    //    if the event finished before the working hours, then plan something
    let last_event = events[events.count - 1]
    let last_event_end_hour = Calendar.current.component(.hour, from: last_event.endDate)

    if workingHoursRange.contains(last_event_end_hour) {
      var components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: last_event.endDate)
      components.hour = workingHoursRange.upperBound
      components.minute = 0
      let end_working_hours = Calendar.current.date(from: components)

      add_event("End of the day", end_working_hours!, end_working_hours!)
    }
    // end of extra virtual event in the end

    for event in events[1 ... events.count - 1] {
      var duration_min : Int = Int(event.startDate.timeIntervalSinceReferenceDate - prev.endDate.timeIntervalSinceReferenceDate) / 60

      if duration_min > 0 {
        if duration_min <= working_mins {
          //              NOTE: It is good for visualiation debug on the  device
          // add_event("Work \(duration_min) min", prev.endDate, event.startDate)
        } else {
          var event_started_at = prev.endDate!
          var event_ended_at = event_started_at
          while duration_min > 0 {
            if duration_min > working_mins {
              event_ended_at = Calendar.current.date(byAdding: working_duration, to: event_started_at)!
              //              NOTE: It is good for visualiation debug on the  device
              //              add_event("Work \(working_mins) min", event_started_at, event_ended_at)
              duration_min = duration_min - working_mins
              event_started_at = event_ended_at
            } else {
              //              NOTE: It is good for visualiation debug on the  device
              //              add_event("Work \(duration_min) min", event_started_at, event.startDate)
              duration_min = 0
            }

            if duration_min <= 0 {
              break
            }

            let routine = next_routine()
            var reminder = Reminder(id: UUID().uuidString, title: "", date: Calendar.current.dateComponents([.hour, .minute], from: event_started_at))

            if duration_min > relaxing_mins {
              event_ended_at = Calendar.current.date(byAdding: relaxing_duration, to: event_started_at)!
              add_event("\(routine) \(relaxing_mins) min", event_started_at, event_ended_at)
              reminder.id = "reminder\(event_started_at.timeIntervalSinceReferenceDate)"
              reminder.title = "\(routine) \(relaxing_mins) min"
              event_started_at = event_ended_at
              duration_min = duration_min - relaxing_mins
            } else {
              add_event("\(routine) \(duration_min) min", event_started_at, event.startDate)
              reminder.id = "reminder\(event_started_at.timeIntervalSinceReferenceDate)"
              reminder.title = "\(routine) \(duration_min) min"
              duration_min = 0
            }
            result.append(reminder)
          }
        }
      }

      prev = event
    }


    return result
  }

  func next_routine() -> String {
    let result = routines.removeFirst()
    routines.append(result)
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

  func schedule_reminder(_ reminder:Reminder) {
    let content = UNMutableNotificationContent()
    content.title = reminder.title
    content.subtitle = "Reminder"
    content.sound = UNNotificationSound.default

    let trigger = UNCalendarNotificationTrigger(dateMatching: reminder.date, repeats: false)
    let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
    center.add(request)

  }
}
