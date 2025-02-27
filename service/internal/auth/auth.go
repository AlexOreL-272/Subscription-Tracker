package auth

import (
	"context"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
)

type LoginResponse struct {
	Id           string `json:"id"`
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

type RegisterResponse struct {
	Id string `json:"id"`
}

type Auth interface {
	Login(
		ctx context.Context,
		email string,
		password string,
	) (*LoginResponse, error)

	Logout(
		ctx context.Context,
		refreshToken string,
	) error

	Register(
		ctx context.Context,
		creds domain.UserCredentials,
	) (*RegisterResponse, error)
}

type EmailVerifier interface {
	SetVerifiedEmail(
		ctx context.Context,
		email string,
	) error
}
