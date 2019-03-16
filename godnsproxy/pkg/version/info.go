package version

// Info represents current build version
type Info struct {
	GitCommit string `json:"gitCommit"`
	GitBranch string `json:"gitBranch"`
	BuildDate string `json:"buildDate"`
	BuildHost string `json:"buildHost"`
	GoVersion string `json:"goVersion"`
	Platform  string `json:"platform"`
	Compiler  string `json:"compiler"`
}

func (info Info) String() string {
	return info.GitCommit
}
