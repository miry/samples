package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "coinmarketcapctl",
	Short: "Client to access coin market",
	Long:  "Client to access coin market",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Hi")
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
