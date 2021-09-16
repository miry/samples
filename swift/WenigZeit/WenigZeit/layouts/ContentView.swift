//
//  ContentView.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import SwiftUI

struct ContentView: View {

  @EnvironmentObject var context : Context

  private enum Tabs: Hashable {
    case calendars, events, settings
  }

  var body: some View {
    TabView {
      CalendarsList()
        .tabItem {
          Label("Calendars", systemImage: "calendar")
        }
        .tag(Tabs.calendars)
      EventsList()
        .tabItem {
          Label("Events", systemImage: "list.bullet.rectangle")
        }
        .tag(Tabs.events)
      SettingsShow()
        .tabItem {
          Label("Settings", systemImage: "gear")
        }
        .tag(Tabs.settings)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Context())
  }
}
