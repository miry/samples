//
//  WenigZeitApp.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import SwiftUI

@main
struct WenigZeitApp: App {
  @StateObject private var context = Context()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(context)
    }
  }
}
