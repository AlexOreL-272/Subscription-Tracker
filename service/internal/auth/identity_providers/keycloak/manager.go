package idpmanager

import (
	"context"
	"encoding/json"

	idprovider "github.com/AlexOreL-272/Subscription-Tracker/internal/auth/identity_providers"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	ctxerror "github.com/AlexOreL-272/Subscription-Tracker/pkg/context_error"
	"golang.org/x/oauth2"
)

type KeycloakOauthConfig struct {
	oauthCfg         *oauth2.Config
	userInfoEndpoint string
	providers        []idprovider.IdentityProvider
}

func New(
	cfg *oauth2.Config,
	userInfoEndpoint string,
	providers ...idprovider.IdentityProvider,
) *KeycloakOauthConfig {
	return &KeycloakOauthConfig{
		cfg,
		userInfoEndpoint,
		providers,
	}
}

func (k *KeycloakOauthConfig) GetRedirectURL(providerType idprovider.IdProviderType) (string, error) {
	// TODO: add state generation
	switch providerType {
	case idprovider.YandexIdProvider:
		return k.oauthCfg.AuthCodeURL(
			"",
			oauth2.SetAuthURLParam("kc_idp_hint", "yandex"),
		), nil

	case idprovider.GoogleIdProvider:
		return k.oauthCfg.AuthCodeURL(
			"",
			oauth2.SetAuthURLParam("kc_idp_hint", "google"),
		), nil

	default:
		return "", idprovider.ErrUnknownProvider
	}
}

func (k *KeycloakOauthConfig) HandleIdPCallback(
	code string,
) (*domain.UserInfo, error) {
	const op = "idprovider.HandleIdPCallback"
	// TODO: add state check

	token, err := k.oauthCfg.Exchange(context.Background(), code)
	if err != nil {
		return nil, ctxerror.New(op, err)
	}

	client := k.oauthCfg.Client(context.Background(), token)

	userInfo, err := client.Get(k.userInfoEndpoint)
	if err != nil {
		return nil, ctxerror.New(op, err)
	}

	var user domain.UserInfo
	if err := json.NewDecoder(userInfo.Body).Decode(&user); err != nil {
		return nil, ctxerror.New(op, err)
	}

	return &user, nil
}
