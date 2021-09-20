//
//  routines_edit.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 19.09.21.
//

import SwiftUI

struct RoutinesList: View {
  @EnvironmentObject var context:Context
  var body: some View {
    List(context.routines) { routine in
      Text(routine.description)
    }
    .navigationTitle("Routines")
    .navigationBarItems(
      trailing: Button(action: {

      }) {
        Image(systemName: "plus")
      }
    )
  }
}

struct RoutinesList_Previews: PreviewProvider {
  static var previews: some View {
    RoutinesList()
      .environmentObject(Context())
  }
}
