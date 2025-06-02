package yandexauth

import (
	"context"
	"encoding/json"
	"errors"

	idprovider "github.com/AlexOreL-272/Subscription-Tracker/internal/auth/identity_providers"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"github.com/google/uuid"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/yandex"
)

/*
	WARN: Автор не смог подключить Яндекс как identity provider'a к Keycloak.
	Поэтому на данный момент обмен токенами происходит напрямую с YandexAPI.
	Подробнее по ссылке: https://github.com/playa-ru/keycloak-russian-providers/issues/60
*/

const (
	yandexUserInfoURL = "https://login.yandex.ru/info"
)

type YandexAuth struct {
	oauthConfig *oauth2.Config
	randomState string
}

func New(
	clientID string,
	clientSecret string,
	redirectURL string,
) *YandexAuth {
	return &YandexAuth{
		oauthConfig: &oauth2.Config{
			ClientID:     clientID,
			ClientSecret: clientSecret,
			RedirectURL:  redirectURL,
			Scopes: []string{
				"login:email",
				"login:info",
			},
			Endpoint: yandex.Endpoint,
		},
		randomState: uuid.New().String(), // TODO: generate random state every request
	}
}

func (y *YandexAuth) AuthCodeURL(useForce bool) string {
	opts := []oauth2.AuthCodeOption{}

	if useForce {
		opts = append(opts, oauth2.SetAuthURLParam("force_confirm", "yes"))
	}

	return y.oauthConfig.AuthCodeURL(y.randomState, opts...)
}

func (y *YandexAuth) GetUserInfo(
	state string,
	code string,
) (*domain.YandexUser, error) {
	if state != y.randomState {
		return nil, idprovider.ErrStateInvalid
	}

	// Exchange code for oauth token
	token, err := y.oauthConfig.Exchange(context.Background(), code)
	if err != nil {
		return nil, errors.Join(idprovider.ErrCodeInvalid, err)
	}

	// Use the token to make API requests
	client := y.oauthConfig.Client(context.Background(), token)

	// Get user info
	resp, err := client.Get(yandexUserInfoURL)
	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()

	var user domain.YandexUser
	if err := json.NewDecoder(resp.Body).Decode(&user); err != nil {
		return nil, err
	}

	return &user, nil
}
