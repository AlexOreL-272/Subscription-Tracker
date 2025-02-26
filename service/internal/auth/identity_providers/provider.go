package idprovider

import (
	"errors"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"golang.org/x/oauth2"
)

var (
	ErrStateInvalid = errors.New("state is invalid")
	ErrCodeInvalid  = errors.New("code is invalid")
)

type IdProviderType string

const (
	YandexIdProvider IdProviderType = "yandex"
	GoogleIdProvider IdProviderType = "google"
)

var (
	ErrUnknownProvider = errors.New("unknown provider")
)

type IdentityProvider interface {
	AuthCodeURL(cfg *oauth2.Config, useForce bool) string
}

type IdentityProviderManager interface {
	GetRedirectURL(providerType IdProviderType) (string, error)
	HandleIdPCallback(code string) (*domain.UserInfo, error)
}
