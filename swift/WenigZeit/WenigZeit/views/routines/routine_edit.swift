//
//  routine_edit.swift
//  WenigZeit
//
//  Created by Michael Nikitochkin on 26.09.21.
//

import SwiftUI

struct RoutineEdit: View {
  @EnvironmentObject var context:Context
  @State var routine: Routine

  var body: some View {
    Form {
      TextField("Title", text: $routine.title)
    }
    .navigationTitle("Edit routine")
    .navigationBarItems(
      trailing: Button(action: save) {
        Text("Done")
      }
    )
  }

  private func save() {
    print("==> save", routine)
//    var r = context.routines.first(
//      where: { routine in
//        routine.id == self.routine.id
//      })!
//    print("current routine", routine, String(format: "%p", routine.title))
//    print("found routine", r, String(format: "%p", r.title))
//    r.title = routine.title
//    for r in context.routines {
//      print(String(format: "%p", r.title))
//    }
    context.routines.append(routine)
  }
}

struct RoutineEdit_Previews: PreviewProvider {
  static var previews: some View {
    RoutineEdit(routine: Routine(title: "Welcome", duration_min: 13))
      .environmentObject(Context())
  }
}
