package gatewayapp

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	emailverifier "github.com/AlexOreL-272/Subscription-Tracker/internal/auth/email/verifier"
	idpmanager "github.com/AlexOreL-272/Subscription-Tracker/internal/auth/identity_providers/keycloak"
	yandexauth "github.com/AlexOreL-272/Subscription-Tracker/internal/auth/identity_providers/yandex"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth/keycloak"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth/pswreset"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/config"
	htmlgenerator "github.com/AlexOreL-272/Subscription-Tracker/internal/html_generator"
	handler "github.com/AlexOreL-272/Subscription-Tracker/internal/http"
	httpmiddleware "github.com/AlexOreL-272/Subscription-Tracker/internal/http/middlewares"
	pgstorage "github.com/AlexOreL-272/Subscription-Tracker/internal/storage/postgres"
	redisstorage "github.com/AlexOreL-272/Subscription-Tracker/internal/storage/redis"
	"github.com/AlexOreL-272/Subscription-Tracker/pkg/notifications/kernel"
	"github.com/go-chi/chi"
	"go.uber.org/zap"
	"golang.org/x/oauth2"
)

var (
	// TODO: use prefix for all endpoints for versioning
	// urlPrefix = "/api/v1"

	authRedirectPath       = "/auth/callback"
	yandexAuthRedirectPath = "/yandex/callback"
)

type Application struct {
	gatewayServer *http.Server
	logger        *zap.Logger
}

type GatewayConfig struct {
	Gateway      config.Gateway
	Keycloak     config.Keycloak
	Database     config.Database
	Redis        config.Redis
	Yandex       config.Yandex
	Notification config.Notification
}

func New(
	cfg GatewayConfig,
	logger *zap.Logger,
) *Application {
	const op = "gatewayapp.New"

	keycloakAddr := fmt.Sprintf("http://%s:%d", cfg.Keycloak.Host, cfg.Keycloak.Port)

	keycloakClient := keycloak.New(
		keycloakAddr,
		cfg.Keycloak.Realm,
		cfg.Keycloak.ClientID,
		cfg.Keycloak.ClientSecret,
	)

	keycloakRedirectURL := fmt.Sprintf("http://alexorel.ru:%d%s", cfg.Gateway.Port, authRedirectPath)

	keycloakOauth2Config := oauth2.Config{
		ClientID:     cfg.Keycloak.ClientID,
		ClientSecret: cfg.Keycloak.ClientSecret,
		RedirectURL:  keycloakRedirectURL,
		Scopes:       []string{"openid", "profile", "email"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  fmt.Sprintf("%s/realms/%s/protocol/openid-connect/auth", keycloakAddr, cfg.Keycloak.Realm),
			TokenURL: fmt.Sprintf("%s/realms/%s/protocol/openid-connect/token", keycloakAddr, cfg.Keycloak.Realm),
		},
	}

	keycloakIdPManager := idpmanager.New(
		&keycloakOauth2Config,
		fmt.Sprintf("%s/realms/%s/protocol/openid-connect/userinfo", keycloakAddr, cfg.Keycloak.Realm),
	)

	pgConnString := fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		cfg.Database.Host,
		cfg.Database.Port,
		cfg.Database.User,
		cfg.Database.Password,
		cfg.Database.DBName,
		cfg.Database.SSLMode,
	)

	postgresDB, err := pgstorage.New(pgConnString)
	if err != nil {
		logger.
			With(zap.String("operation", op)).
			Error("failed to connect to database", zap.Error(err))
	}

	redisConnString := fmt.Sprintf(
		"%s:%d",
		cfg.Redis.Host,
		cfg.Redis.Port,
	)

	redisStorage, err := redisstorage.New(redisConnString)
	if err != nil {
		logger.
			With(zap.String("operation", op)).
			Error("failed to connect to redis", zap.Error(err))
	}

	yandexAuth := yandexauth.New(
		cfg.Yandex.ClientID,
		cfg.Yandex.ClientSecret,
		fmt.Sprintf("http://alexorel.ru%s", yandexAuthRedirectPath),
	)

	notifSender := kernel.New(
		kernel.KernelConfig{
			Email: &kernel.EmailConfig{
				SmtpServerHost: cfg.Notification.Email.SmtpServerHost,
				SmtpServerPort: cfg.Notification.Email.SmtpServerPort,
				SmtpUsername:   cfg.Notification.Email.SmtpUsername,
				SmtpPassword:   cfg.Notification.Email.SmtpPassword,
			},
		},
		kernel.SenderCredentials{
			SenderEmail:    cfg.Notification.Email.SenderEmail,
			SenderNickname: cfg.Notification.Email.SenderNickname,
		},
		logger,
	)

	emailVerifier, err := emailverifier.New(
		pgConnString,
		keycloakClient,
	)
	if err != nil {
		logger.
			With(zap.String("operation", op)).
			Error("failed to create email verifier", zap.Error(err))

		panic(err) // TODO: think about retries
	}

	emailGenerator := htmlgenerator.New(cfg.Notification.Email.TemplatesPath)

	passwordResetter := pswreset.New(
		redisStorage,
		keycloakClient,
		emailGenerator,
		notifSender,
	)

	httpHandler := handler.New(
		keycloakClient,     // auth.Auth
		keycloakIdPManager, // idpmanager.IdentityProviderManager
		postgresDB,         // storage.UserSaver
		postgresDB,         // storage.SubscriptionSaver
		postgresDB,         // storage.SubscriptionProvider
		postgresDB,         // storage.SubscriptionEditor
		postgresDB,         // storage.SubscriptionDeleter
		notifSender,        // notifications.NotificationSender
		emailVerifier,      // emailverifier.Verifier
		passwordResetter,   // auth.PasswordResetter
		emailGenerator,     // htmlgenerator.EmailHTMLGenerator
		logger,             // *zap.Logger

		yandexAuth, // yandexauth.YandexAuth
	)

	staticHandler := handler.NewStaticFileHandler(cfg.Notification.Static.TemplatesPath)

	loggingMiddleware := httpmiddleware.NewLoggingInterceptor(logger)

	router := chi.NewRouter()
	setupRouter(
		router,
		httpHandler,
		staticHandler,
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
	static *handler.StaticFileHandler,
	middlewares ...func(next http.Handler) http.Handler,
) {
	// middlewares
	router.Use(middlewares...)

	// TODO: use subrouter and assign middlewares to it
	router.Get("/", handler.Echo)

	// <=========== AUTH ENDPOINTS ===========>
	router.Post("/register", handler.Register)
	router.Post("/login", handler.Login)

	router.Get("/auth", handler.AuthWithIdentityProvider)
	router.Get(authRedirectPath, handler.AuthCallback)

	router.Get("/yandex/login", handler.LoginWithYandex)
	router.Get(yandexAuthRedirectPath, handler.YandexCallback)

	// <=========== EMAIL ENDPOINTS ===========>
	router.Get("/verify_email", handler.VerifyEmail)

	router.Get("/verify", static.ServeVerifyEmailPage)
	router.Get("/success_verification", static.ServeSuccessVerificationPage)

	// request password reset
	router.Post("/request_password_reset", handler.RequestPasswordReset)
	// make actual password reset
	router.Post("/reset_password", handler.ResetPassword)

	// serve the forgot password page
	router.Get("/forgot_password", static.ServeForgotPasswordPage)
	// serve the success reset page
	router.Get("/success_reset", static.ServeSuccessResetPage)

	// <=========== SUBSCRIPTION ENDPOINTS ===========>
	router.Get("/subscriptions", handler.GetSubscriptions)
	router.Get("/subscriptions/{sub_id}", handler.GetSubscriptionById)
	router.Post("/subscriptions", handler.CreateSubscription)
	router.Put("/subscriptions/{sub_id}", handler.EditSubscription)
	router.Delete("/subscriptions/{sub_id}", handler.DeleteSubscription)
}
