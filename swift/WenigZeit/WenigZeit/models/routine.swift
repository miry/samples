//
//  routine.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 19.09.21.
//

import Foundation

struct Routine: Identifiable, CustomStringConvertible {
  let id: String = UUID().uuidString
  var title: String
  var duration_min: Int

  var description:String {
    return "\(title) (\(duration_min) min)"
  }
}
