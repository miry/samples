//
//  calendars_list.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 13.09.21.
//

import SwiftUI
import EventKit

struct CalendarsList: View {

  @EnvironmentObject var context: Context

  var body: some View {
    List {
      ForEach(context.calendars, id: \.self) { calendar in
        HStack {
          Text(calendar.title)
            .foregroundColor(Color.init(calendar.cgColor))
          Spacer()
        }
      }
    }
  }
}

struct calendars_list_Previews: PreviewProvider {
  static var previews: some View {
    CalendarsList()
      .environmentObject(Context())
      .previewLayout(.fixed(width: 300, height: 170))
  }
}
