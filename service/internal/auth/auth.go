package auth

import "github.com/AlexOreL-272/Subscription-Tracker/internal/domain"

type Auth interface {
	Login(
		email string,
		password string,
	) error

	Logout() error

	Register(creds domain.UserCredentials) error
}
