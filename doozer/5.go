// DOOZER Application test
// Please adjust the code as required in the task description and share us the link to your solution.
package main

import (
	"fmt"
)

const (
	FlagEdit   uint8 = 1
	FlagRead   uint8 = 2
	FlagDelete uint8 = 4
)

func CanEdit(flags uint8) bool {
	return flags&1 == FlagEdit
}

func CanRead(flags uint8) bool {
	return flags&2 == FlagRead
}

func CanDelete(flags uint8) bool {
	return flags&4 == FlagDelete
}

// 5.
// There are 3 available actions to perform: edit, read, delete. These actions are defined in an uint8, all actions
// may be stored .
// - Write 3 methods to check whether an integer contains a certain action, called: CanEdit, CanRead, CanDelete and
//   implement them based on the following type.
// - Declare the flags (edit, read, delete) as enumerated constants named: "FlagEdit", "FlagRead", "FlagDelete"
type CanPerformAction func(uint8) bool

func main() {
	testCases := []struct {
		flags                       uint8
		canEdit, canRead, canDelete bool
	}{
		{0, false, false, false},
		{FlagEdit, true, false, false},
		{FlagRead, false, true, false},
		{FlagEdit | FlagRead, true, true, false},
		{FlagDelete, false, false, true},
		{FlagEdit | FlagDelete, true, false, true},
		{FlagRead | FlagDelete, false, true, true},
		{FlagEdit | FlagRead | FlagDelete, true, true, true},
	}

	for _, tc := range testCases {
		if r := CanEdit(tc.flags); r != tc.canEdit {
			fmt.Printf("edit: got %v; want %v\n", r, tc.canEdit)
		}
		if r := CanRead(tc.flags); r != tc.canRead {
			fmt.Printf("read: got %v; want %v\n", r, tc.canRead)
		}
		if r := CanDelete(tc.flags); r != tc.canDelete {
			fmt.Printf("delete: got %v; want %v\n", r, tc.canDelete)
		}
	}
}
