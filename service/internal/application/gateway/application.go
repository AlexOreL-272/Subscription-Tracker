package gatewayapp

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	yandexauth "github.com/AlexOreL-272/Subscription-Tracker/internal/auth/identity_providers/yandex"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth/keycloak"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/config"
	handler "github.com/AlexOreL-272/Subscription-Tracker/internal/http"
	httpmiddleware "github.com/AlexOreL-272/Subscription-Tracker/internal/http/middlewares"
	pgstorage "github.com/AlexOreL-272/Subscription-Tracker/internal/storage/postgres"
	"github.com/go-chi/chi"
	"go.uber.org/zap"
)

const (
	// TODO: use prefix for all endpoints for versioning
	// urlPrefix = "/api/v1"

	yandexAuthRedirectPath = "/yandex/callback"
)

type Application struct {
	gatewayServer *http.Server
	logger        *zap.Logger
}

type GatewayConfig struct {
	Gateway  config.Gateway
	Keycloak config.Keycloak
	Database config.Database
	Yandex   config.Yandex
}

func New(
	cfg GatewayConfig,
	logger *zap.Logger,
) *Application {
	const op = "gatewayapp.New"

	keycloakClient := keycloak.New(
		fmt.Sprintf("%s:%d", cfg.Keycloak.Host, cfg.Keycloak.Port),
		cfg.Keycloak.Realm,
		cfg.Keycloak.ClientID,
		cfg.Keycloak.ClientSecret,
	)

	postgresDB, err := pgstorage.New(fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		cfg.Database.Host,
		cfg.Database.Port,
		cfg.Database.User,
		cfg.Database.Password,
		cfg.Database.DBName,
		cfg.Database.SSLMode,
	))
	if err != nil {
		logger.
			With(zap.String("operation", op)).
			Error("failed to connect to database", zap.Error(err))
	}

	yandexAuth := yandexauth.New(
		cfg.Yandex.ClientID,
		cfg.Yandex.ClientSecret,
		fmt.Sprintf("http://alexorel.ru%s", yandexAuthRedirectPath),
	)

	handler := handler.New(
		keycloakClient,
		postgresDB,
		postgresDB,
		postgresDB,
		postgresDB,
		postgresDB,
		logger,

		yandexAuth,
	)

	loggingMiddleware := httpmiddleware.NewLoggingInterceptor(logger)

	router := chi.NewRouter()
	setupRouter(
		router,
		handler,
		loggingMiddleware.Intercept,
	)

	srv := &http.Server{
		Addr:    fmt.Sprintf("%s:%d", cfg.Gateway.Host, cfg.Gateway.Port),
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
	middlewares ...func(next http.Handler) http.Handler,
) {
	// middlewares
	router.Use(middlewares...)

	// TODO: use subrouter and assign middlewares to it
	router.Get("/", handler.Echo)

	// auth endpoints
	router.Post("/register", handler.Register)
	router.Post("/login", handler.Login)

	router.Get("/yandex/login", handler.LoginWithYandex)
	router.Get(yandexAuthRedirectPath, handler.YandexCallback)

	// subscription endpoints
	router.Get("/subscriptions", handler.GetSubscriptions)
	router.Get("/subscriptions/{sub_id}", handler.GetSubscriptionById)
	router.Post("/subscriptions", handler.CreateSubscription)
	router.Put("/subscriptions/{sub_id}", handler.EditSubscription)
	router.Delete("/subscriptions/{sub_id}", handler.DeleteSubscription)
}
