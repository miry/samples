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
  let event_store = EKEventStore()
  let notification_center = UNUserNotificationCenter.current()

  private var start_working_date: Date
  private var end_working_date: Date

  @Published var calendars: [EKCalendar] = []
  @Published var events: [EKEvent] = []
  @Published var workingHoursRange = 10..<22
  @Published var working_mins : Int = 30
  @Published var routines: [Routine] = [
    Routine(title: "Workout", duration_min: 15),
    Routine(title: "Deutsch", duration_min: 5),
    Routine(title: "Today tasks", duration_min: 15),
    Routine(title: "Push ups", duration_min: 1),
    Routine(title: "Walk 2000 steps", duration_min: 30),
    Routine(title: "Review daily tasks", duration_min: 10),
    Routine(title: "Read book", duration_min: 15),
    Routine(title: "Running", duration_min: 15),
  ]

  @Published var enableReminders = UserDefaults.standard.bool(forKey: "enableReminders") {
    didSet {
      UserDefaults.standard.setValue(enableReminders, forKey: "enableReminders")
    }
  }

  init() {
    start_working_date = Date()
    end_working_date = Date()
    request_access()
    refresh(true)
  }

  func refresh(_ create_reminders: Bool) {
    let accessCalendar = EKEventStore.authorizationStatus(for: .event)
    guard  accessCalendar == .authorized else {
      print("WARNING: No access to calendar events!")
      return
    }

    calendars = fetch_calendars()
    events = fetch_events()

    let original_routines = routines
    let reminders = plan_routines_reminders()
    routines = original_routines

    events.sort {
      $0.startDate < $1.startDate
    }

    notification_center.removeAllPendingNotificationRequests()
    let schedule_reminders = enableReminders && create_reminders
    if schedule_reminders {
      print("Schedule reminders")
      for reminder in reminders {
        schedule_reminder(reminder)
      }
    }

    // Debug reminders:
    notification_center.getPendingNotificationRequests {requests in
      print("Notifications pending:")
      for request in requests {
        print("Schdudeled: \(request.identifier) \(request.content.title)")
      }
    }
  }

  func request_access() {
    event_store.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
      if !granted {
        print("WARNING: Couldn't grant access to calendars")
      }
    })
    request_access_enable_notifications()
  }

  func request_access_enable_notifications() {
    notification_center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if !granted {
        print("WARNING: Couldn't grant access to notifications")
      }
    }
  }

  func fetch_calendars() -> [EKCalendar] {
    var result: [EKCalendar] = []

    for calendar in event_store.calendars(for: EKEntityType.event) {
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
    //    Identify the start of the events today at 10 hours or tomorrow at 10 hours
    //    If it is already late, then show plan for tomorrow
    var components = Foundation.Calendar.current.dateComponents([.year, .month, .day, .hour], from: now)
    if components.hour! >= workingHoursRange.upperBound {
      components.day = components.day! + 1
    }
    components.hour = workingHoursRange.lowerBound
    components.minute = 0
    start_working_date = Foundation.Calendar.current.date(from: components)!

    components.hour = workingHoursRange.upperBound
    end_working_date = Foundation.Calendar.current.date(from: components)!
    //    end of calculating the day

    let predicate = event_store.predicateForEvents(
      withStart: start_working_date,
      end: end_working_date,
      calendars: calendars)
    let events = event_store.events(matching: predicate)

    for event in events {
      if event.isAllDay ||
          event.status != EKEventStatus.confirmed ||
          event.availability != EKEventAvailability.busy {
        print("skipped event: ", String(event.title))
        continue
      }

      print("> Checking working hours range")
      let eventStartHour = Foundation.Calendar.current.component(.hour, from: event.startDate)
      if !workingHoursRange.contains(eventStartHour) {
        //        print("skipped event: ", String(event.title))
        continue
      }

      print("> Check for duplication")
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

    if result.count == 0 || workingHoursRange.contains(Foundation.Calendar.current.component(.hour, from: result[0].startDate)) {
      result.insert(create_event("Start of the day", start_working_date, start_working_date), at: 0)
    }

    if result.count == 1 || workingHoursRange.contains(Foundation.Calendar.current.component(.hour, from: result[result.count-1].startDate)) {
      result.append(create_event("End of the day", end_working_date, end_working_date))
    }

    return result
  }

  // Build a timetable for routines
  func plan_routines_reminders() -> [Reminder] {
    let working_duration = DateComponents(calendar: Foundation.Calendar.current, minute: working_mins)

    if events.count == 0 {
      return []
    }

    // Schedule the empty slots
    print("======= scheduele")
    var prev : EKEvent = events[0]
    var result : [Reminder] = []

    let now = Date()

    for event in events[1 ... events.count - 1] {
      var duration_min : Int = Int(event.startDate.timeIntervalSinceReferenceDate - prev.endDate.timeIntervalSinceReferenceDate) / 60
      print("fill space between", prev, event)
      print("duration(min): ", duration_min)

      if duration_min > 0 {
        if duration_min <= working_mins {
          //              NOTE: It is good for visualiation debug on the  device
          // add_event("Work \(duration_min) min", prev.endDate, event.startDate)
        } else {
          var event_started_at = prev.endDate!
          var event_ended_at = event_started_at
          while duration_min > 0 {
            if duration_min > working_mins {
              event_ended_at = Foundation.Calendar.current.date(byAdding: working_duration, to: event_started_at)!
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
            let relaxing_mins = routine.duration_min
            let relaxing_duration = DateComponents(calendar: Foundation.Calendar.current, minute: relaxing_mins)

            var reminder = Reminder(id: UUID().uuidString, title: "", date: Foundation.Calendar.current.dateComponents([.hour, .minute], from: event_started_at))

            if duration_min > relaxing_mins {
              event_ended_at = Foundation.Calendar.current.date(byAdding: relaxing_duration, to: event_started_at)!
              let e = create_event(routine.description, event_started_at, event_ended_at)
              events.append(e)
              reminder.id = "reminder\(event_started_at.timeIntervalSinceReferenceDate)"
              reminder.title = routine.description
              event_started_at = event_ended_at
              duration_min = duration_min - relaxing_mins
            } else {
              let e = create_event(routine.description, event_started_at, event.startDate)
              events.append(e)
              reminder.id = "reminder\(event_started_at.timeIntervalSinceReferenceDate)"
              reminder.title = routine.description
              duration_min = 0
            }

            if event_started_at > now {
              result.append(reminder)
            } else {
              print("no schedule for routine \(routine)")
            }
          }
        }
      }

      prev = event
    }


    return result
  }

  func next_routine() -> Routine {
    let result = routines.removeFirst()
    routines.append(result)
    return result
  }

  func create_event(_ title:String, _ start:Date, _ end:Date) -> EKEvent {
    let reserver:EKEvent = EKEvent(eventStore: event_store)
    reserver.title = title
    reserver.startDate = start
    reserver.endDate = end
    reserver.calendar = event_store.defaultCalendarForNewEvents
    return reserver
  }

  func schedule_reminder(_ reminder:Reminder) {
    let content = UNMutableNotificationContent()
    content.title = reminder.title
    content.subtitle = "Reminder"
    content.sound = UNNotificationSound.default

    let trigger = UNCalendarNotificationTrigger(dateMatching: reminder.date, repeats: false)
    let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
    notification_center.add(request)
  }
}
