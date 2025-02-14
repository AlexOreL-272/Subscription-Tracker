package application

import (
	"fmt"

	gatewayapp "github.com/AlexOreL-272/Subscription-Tracker/internal/application/gateway"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/config"
	"go.uber.org/zap"
)

type Application struct {
	apiGateway *gatewayapp.Application
}

func New(
	cfg *config.Config,
	logger *zap.Logger,
) *Application {
	gatewayConfig := gatewayapp.GatewayConfig{
		Host:                 cfg.Gateway.Host,
		Port:                 cfg.Gateway.Port,
		KeycloakAddress:      fmt.Sprintf("%s:%d", cfg.Keycloak.Host, cfg.Keycloak.Port),
		KeycloakRealm:        cfg.Keycloak.Realm,
		KeycloakRealmAdmin:   cfg.Keycloak.RealmAdmin,
		KeycloakClientID:     cfg.Keycloak.ClientID,
		KeycloakClientSecret: cfg.Keycloak.ClientSecret,
		KeycloakAdminUser:    cfg.Keycloak.AdminUser,
		KeycloakAdminPass:    cfg.Keycloak.AdminPass,
	}

	apiGateway := gatewayapp.New(gatewayConfig, logger)

	return &Application{
		apiGateway: apiGateway,
	}
}

func (a *Application) MustStart() {
	go a.apiGateway.MustStart()
}

func (a *Application) Shutdown() {
	a.apiGateway.Shutdown()
}
