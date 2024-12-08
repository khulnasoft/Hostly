package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Current Hostly CLI version",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(CliVersion)
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
