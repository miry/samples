package app_test

import (
	"fmt"

	"github.com/miry/wattx_top_coins/pkg/app"
)

func ExampleNewApp() {
	_, err := app.NewApp()
	if err != nil {
		fmt.Println(err)
	}

	// Output:
}
