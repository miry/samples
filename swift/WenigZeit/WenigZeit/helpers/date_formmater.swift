//
//  date_formmater.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 26.09.21.
//

import Foundation

let DateFormatter: ISO8601DateFormatter = {
  let result = ISO8601DateFormatter()
  result.formatOptions = .withFullDate
  return result
}()
