//
//  reminder.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 25.09.21.
//

import Foundation

struct Reminder: Hashable, Identifiable {
  var id: String
  var title: String
  var date: DateComponents
}
