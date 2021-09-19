//
//  settings.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 16.09.21.
//

import SwiftUI
import EventKitUI

struct SettingsShow: View {

  private enum Tabs: Hashable {
    case calendars, about
  }

  var body: some View {
    TabView {
      CalendarsList()
        .tabItem {
          Label("Calendars", systemImage: "calendar")
        }
        .tag(Tabs.calendars)
      AboutShow()
        .tabItem { Label("About", systemImage: "info") }
        .tag(Tabs.about)
    }
  }
}

struct SettingsShow_Previews: PreviewProvider {
  static var previews: some View {
    SettingsShow()
  }
}
