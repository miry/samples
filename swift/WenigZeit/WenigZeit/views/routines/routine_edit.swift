//
//  routine_edit.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 26.09.21.
//

import SwiftUI

struct RoutineEdit: View {
  @State var routine: Routine

  var body: some View {
    Form {

    }
    .navigationTitle("Edit routine")
  }
}

struct RoutineEdit_Previews: PreviewProvider {
  static var previews: some View {
    RoutineEdit(routine: Routine(title: "Welcome", duration_min: 13))
  }
}
