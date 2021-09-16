//
//  event.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import Foundation

struct Event: Hashable, Identifiable {
  var id: Int
  var name: String
  var description: String
  var startDate: Date
  var occurrenceDate: Date
  var calendar: String 
}
