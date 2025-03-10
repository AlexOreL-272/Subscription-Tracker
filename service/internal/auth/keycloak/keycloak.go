package keycloak

import (
	"context"
	"errors"
	"fmt"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	ctxerror "github.com/AlexOreL-272/Subscription-Tracker/pkg/context_error"
	"github.com/Nerzal/gocloak/v13"
)

var (
	ErrNoSuchUser = errors.New("error: no such user")
)

type KeycloakClient struct {
	client       *gocloak.GoCloak
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
		client:       gocloak.NewClient(address),
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

	token, err := k.client.LoginClient(
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

	id, err := k.client.CreateUser(ctx, token.AccessToken, k.realm, user)
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

	token, err := k.client.Login(
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

	user, err := k.client.GetUserInfo(
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

	if err := k.client.Logout(
		ctx,
		k.clientID,
		k.clientSecret,
		k.realm,
		refreshToken,
	); err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	if err := k.client.RevokeToken(
		ctx,
		k.realm,
		k.clientID,
		k.clientSecret,
		refreshToken,
	); err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (k *KeycloakClient) SetVerifiedEmail(
	ctx context.Context,
	email string,
) error {
	const op = "keycloak.SetVerifiedEmail"

	token, err := k.client.LoginClient(
		ctx,
		k.clientID,
		k.clientSecret,
		k.realm,
	)
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	users, err := k.client.GetUsers(
		ctx,
		token.AccessToken,
		k.realm,
		gocloak.GetUsersParams{
			Email: gocloak.StringP(email),
		},
	)
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	if len(users) == 0 {
		return fmt.Errorf("%s: %w", op, ErrNoSuchUser)
	}

	updatedUser := gocloak.User{
		ID:            users[0].ID,
		EmailVerified: gocloak.BoolP(true),
	}

	if err := k.client.UpdateUser(
		ctx,
		token.AccessToken,
		k.realm,
		updatedUser,
	); err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (k *KeycloakClient) ResetPassword(
	ctx context.Context,
	email, newPassword string,
) error {
	const op = "keycloak.KeycloakClient.ResetPassword"

	token, err := k.client.LoginClient(
		ctx,
		k.clientID,
		k.clientSecret,
		k.realm,
	)
	if err != nil {
		return ctxerror.New(op, err)
	}

	users, err := k.client.GetUsers(
		ctx,
		token.AccessToken,
		k.realm,
		gocloak.GetUsersParams{
			Email: gocloak.StringP(email),
		},
	)
	if err != nil {
		return ctxerror.New(op, err)
	}

	if len(users) == 0 {
		return ctxerror.New(op, ErrNoSuchUser)
	}

	if err := k.client.SetPassword(
		ctx,
		token.AccessToken,
		*users[0].ID,
		k.realm,
		newPassword,
		false,
	); err != nil {
		return ctxerror.New(op, err)
	}

	return nil
}
