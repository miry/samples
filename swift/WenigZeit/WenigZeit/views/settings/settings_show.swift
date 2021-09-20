//
//  settings.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 16.09.21.
//

import SwiftUI
import EventKitUI

struct SettingsRowView: View {
  var title: String
  var iconName: String

  var body: some View {
    HStack {
      Image(systemName: iconName)
      Text (title)
    }
  }
}

struct SettingsShow: View {

  @EnvironmentObject var context: Context

  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        Form {
          Toggle("Notifications", isOn: $context.enableReminders)
        }

        List {
          NavigationLink(destination: CalendarsList(), label: {
            SettingsRowView(
              title: "Calendars",
              iconName: "calendar"
            )
          })

          NavigationLink(destination: RoutinesList(), label: {
            SettingsRowView(
              title: "Routines",
              iconName: "person"
            )
          })
        }

        Spacer()
      }
      .navigationTitle("Settings")
    }
  }
}

struct SettingsShow_Previews: PreviewProvider {
  static var previews: some View {
    SettingsShow()
  }
}
