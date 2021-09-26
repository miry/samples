//
//  routines_edit.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 19.09.21.
//

import SwiftUI

struct RoutinesList: View {

  @EnvironmentObject var context:Context

  private func delete(atOffsets offsets: IndexSet) {
    context.routines.remove(atOffsets: offsets)
  }

  private func move(fromOffsets from: IndexSet, toOffset to: Int) {
    context.routines.move(fromOffsets: from, toOffset: to)
  }

  var body: some View {
    List {
      ForEach(context.routines) { routine in
        Text(routine.description)
      }
      .onDelete(perform: delete)
      .onMove(perform: move(fromOffsets:toOffset:))
    }
    .environment(\.editMode, .constant(EditMode.active))
    .navigationTitle("Routines")
    .navigationBarItems(
      trailing: Button(action: {} ) {
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
