package version

import (
	"fmt"
	"runtime"
)

// Get returns the overall codebase version. It's for detecting
// what code a binary was built from.
func Get() Info {
	return Info{
		GitCommit: gitCommit,
		GitBranch: gitBranch,
		BuildDate: buildDate,
		BuildHost: buildHost,
		GoVersion: runtime.Version(),
		Compiler:  runtime.Compiler,
		Platform:  fmt.Sprintf("%s/%s", runtime.GOOS, runtime.GOARCH),
	}
}
