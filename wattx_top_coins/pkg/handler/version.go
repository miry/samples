package handler

import (
	"encoding/json"
	"net/http"

	"github.com/miry/wattx_top_coins/pkg/app"
	"github.com/miry/wattx_top_coins/pkg/version"
)

// VersionHandler process version endpoint
type VersionHandler struct {
	app *app.App
}

type versionResp struct {
	GitHash       string `json:"git_hash"`
	GitBranch     string `json:"git_branch"`
	BuildDate     string `json:"build_date"`
	BuildUnixTime int    `json:"build_unix_time"`
}

// NewVersionHandler initialize VersionHandler object
func NewVersionHandler(app *app.App) *VersionHandler {
	return &VersionHandler{app: app}
}

// Show build response of current version
func (h *VersionHandler) Show(w http.ResponseWriter, r *http.Request) {
	resp := version.Get()
	if err := json.NewEncoder(w).Encode(resp); err != nil {
		http.Error(w, err.Error(), 500)
		h.app.Logger.Error().Err(err).Msg("Could not render version")
	}
}
