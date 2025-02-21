package keycloak

import (
	"context"
	"errors"
	"fmt"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"github.com/Nerzal/gocloak/v13"
)

var (
	ErrNoSuchUser = errors.New("error: no such user")
)

type KeycloakClient struct {
	baseURL      string
	realm        string
	clientID     string
	clientSecret string
}

func New(
	address string,
	realm string,
	clientID string,
	clientSecret string,
) *KeycloakClient {
	return &KeycloakClient{
		baseURL:      fmt.Sprintf("http://%s", address),
		realm:        realm,
		clientID:     clientID,
		clientSecret: clientSecret,
	}
}

func (k *KeycloakClient) Register(
	ctx context.Context,
	creds domain.UserCredentials,
) (*auth.RegisterResponse, error) {
	const op = "keycloak.Register"

	keycloakClient := gocloak.NewClient(k.baseURL)

	token, err := keycloakClient.LoginClient(
		ctx,
		k.clientID,
		k.clientSecret,
		k.realm,
	)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	user := gocloak.User{
		FirstName: &creds.FullName,
		LastName:  &creds.Surname,
		Email:     &creds.Email,
		Enabled:   gocloak.BoolP(true),
		Credentials: &[]gocloak.CredentialRepresentation{
			{
				Type:      gocloak.StringP("password"),
				Value:     gocloak.StringP(creds.Password),
				Temporary: gocloak.BoolP(false),
			},
		},
	}

	id, err := keycloakClient.CreateUser(ctx, token.AccessToken, k.realm, user)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	return &auth.RegisterResponse{
		Id: id,
	}, nil
}

func (k *KeycloakClient) Login(
	ctx context.Context,
	email string,
	password string,
) (*auth.LoginResponse, error) {
	const op = "keycloak.Login"

	keycloakClient := gocloak.NewClient(k.baseURL)

	token, err := keycloakClient.Login(
		ctx,
		k.clientID,
		k.clientSecret,
		k.realm,
		email,
		password,
	)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	user, err := keycloakClient.GetUserInfo(
		ctx,
		token.AccessToken,
		k.realm,
	)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	return &auth.LoginResponse{
		Id:           *user.Sub,
		AccessToken:  token.AccessToken,
		RefreshToken: token.RefreshToken,
	}, nil
}

func (k *KeycloakClient) Logout(
	ctx context.Context,
	refreshToken string,
) error {
	const op = "keycloak.Logout"

	keycloakClient := gocloak.NewClient(k.baseURL)

	if err := keycloakClient.Logout(
		ctx,
		k.clientID,
		k.clientSecret,
		k.realm,
		refreshToken,
	); err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}
