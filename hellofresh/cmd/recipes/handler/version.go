package handler

import (
	"encoding/json"
	"net/http"

	"github.com/miry/samples/hellofresh/cmd/recipes/app"
	"github.com/miry/samples/hellofresh/pkg/conf"
)

type VersionHandler struct {
	app *app.App
}

type versionResp struct {
	GitHash       string `json:"git_hash"`
	GitBranch     string `json:"git_branch"`
	BuildDate     string `json:"build_date"`
	BuildUnixTime int    `json:"build_unix_time"`
}

func NewVersionHandler(app *app.App) *VersionHandler {
	return &VersionHandler{app: app}
}

func (h *VersionHandler) Show(w http.ResponseWriter, r *http.Request) {
	resp := versionResp{conf.GitHash, conf.GitBranch, conf.BuildDate, conf.BuildUnixTime}
	if err := json.NewEncoder(w).Encode(resp); err != nil {
		http.Error(w, err.Error(), 500)
		h.app.Logger.Error().Err(err).Msg("Could not render version")
	}
}
