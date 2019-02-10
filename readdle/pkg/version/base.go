package version

// When releasing a new chat version, this file is updated by
// build/generate-version to reflect the new version, is created to point to the commit that updates
// pkg/version/base_generated.go
// To ignore changes in this file https://stackoverflow.com/questions/10755655/git-ignore-tracked-files
// git update-index --assume-unchanged pkg/version/base.go
// if require changes
// git update-index --no-assume-unchanged pkg/version/base.go
// Other solutions: https://www.youtube.com/watch?v=-XSlev-d7UY

//go:generate ./../../build/generate-version

var (
	// NOTE: The $Format strings are replaced during 'git archive' thanks to the
	// companion .gitattributes file containing 'export-subst' in this same
	// directory.  See also https://git-scm.com/docs/gitattributes
	gitCommit = "$Format:%H$"  // sha1 from git, output of $(git rev-parse HEAD) https://git-scm.com/docs/git-log
	gitBranch = "$Format:%D$"  // branch name https://git-scm.com/docs/git-log
	gitUser   = "$Format:%an$" // author name https://git-scm.com/docs/git-log
	buildHost = "localhost"
	buildDate = "1970-01-01T00:00:00Z" // build date in ISO8601 format, output of $(date -u +'%Y-%m-%dT%H:%M:%SZ')
)
