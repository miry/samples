//
//  routine_edit.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 19.09.21.
//

import SwiftUI

struct RoutineCreate: View {
  @State var routine: Routine
  var body: some View {
    Form {
      Text(routine.title)
    }
    .navigationTitle("New routine")
  }
}

struct RoutineCreate_Previews: PreviewProvider {
  static var previews: some View {
    RoutineCreate(routine: Routine(title: "Test", duration_min: 1))
  }
}
