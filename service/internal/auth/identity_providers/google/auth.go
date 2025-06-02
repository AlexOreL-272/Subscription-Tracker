package googleauth

import "golang.org/x/oauth2"

type GoogleAuth struct {
}

func New() *GoogleAuth {
	return &GoogleAuth{}
}

func (g *GoogleAuth) AuthCodeURL(cfg *oauth2.Config, useForce bool) string {
	opts := []oauth2.AuthCodeOption{
		oauth2.AccessTypeOffline,
		oauth2.SetAuthURLParam("kc_idp_hint", "google"),
	}

	if useForce {
		opts = append(opts, oauth2.ApprovalForce)
	}

	return cfg.AuthCodeURL("", opts...)
}
