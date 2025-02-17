package gatewayapp

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth/keycloak"
	handler "github.com/AlexOreL-272/Subscription-Tracker/internal/http"
	"github.com/go-chi/chi"
	"go.uber.org/zap"
)

type Application struct {
	gatewayServer *http.Server
	logger        *zap.Logger
}

type GatewayConfig struct {
	Host string
	Port int

	KeycloakAddress      string
	KeycloakRealm        string
	KeycloakRealmAdmin   string
	KeycloakClientID     string
	KeycloakClientSecret string
	KeycloakAdminUser    string
	KeycloakAdminPass    string
}

func New(
	cfg GatewayConfig,
	logger *zap.Logger,
) *Application {
	keycloakClient := keycloak.New(
		cfg.KeycloakAddress,
		cfg.KeycloakRealm,
		cfg.KeycloakRealmAdmin,
		cfg.KeycloakClientID,
		cfg.KeycloakClientSecret,
		cfg.KeycloakAdminUser,
		cfg.KeycloakAdminPass,
	)

	handler := handler.New(keycloakClient, logger)

	router := chi.NewRouter()
	setupRouter(router, handler)

	srv := &http.Server{
		Addr:    fmt.Sprintf("%s:%d", cfg.Host, cfg.Port),
		Handler: router,
	}

	return &Application{
		gatewayServer: srv,
		logger:        logger,
	}
}

func (a *Application) MustStart() {
	if err := a.start(); err != nil {
		panic(err)
	}
}

func (a *Application) start() error {
	const op = "gatewayapp.Application.start"

	a.logger.
		With(zap.String("operation", op)).
		Info("starting API Gateway application")

	if err := a.gatewayServer.ListenAndServe(); err != nil {
		if errors.Is(err, http.ErrServerClosed) {
			return nil
		}

		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (a *Application) Shutdown() {
	const op = "gatewayapp.Application.Shutdown"

	a.logger.
		With(zap.String("operation", op)).
		Info("shutting down")

	ctx := context.Background()
	if err := a.gatewayServer.Shutdown(ctx); err != nil {
		a.logger.
			With(zap.String("operation", op)).
			Error("failed to shutdown", zap.Error(err))
	}
}

func setupRouter(
	router *chi.Mux,
	handler *handler.Handler,
) {
	// use URL paths and middlewares
	router.Get("/", handler.Echo)

	router.Post("/register", handler.Register)
	router.Post("/login", handler.Login)
}
