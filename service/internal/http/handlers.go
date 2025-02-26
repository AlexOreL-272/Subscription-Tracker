package http

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth"
	idprovider "github.com/AlexOreL-272/Subscription-Tracker/internal/auth/identity_providers"
	yandexauth "github.com/AlexOreL-272/Subscription-Tracker/internal/auth/identity_providers/yandex"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/storage"
	"github.com/go-chi/chi"
	"go.uber.org/zap"
)

type Handler struct {
	logger      *zap.Logger
	authClient  auth.Auth
	idPManager  idprovider.IdentityProviderManager
	userSaver   storage.UserSaver
	subSaver    storage.SubscriptionSaver
	subProvider storage.SubscriptionProvider
	subEditor   storage.SubscriptionEditor
	subDeleter  storage.SubscriptionDeleter

	// TODO: use in keycloak
	yandexAuth *yandexauth.YandexAuth
}

func New(
	authClient auth.Auth,
	idPManager idprovider.IdentityProviderManager,
	userSaver storage.UserSaver,
	subSaver storage.SubscriptionSaver,
	subProvider storage.SubscriptionProvider,
	subEditor storage.SubscriptionEditor,
	subDeleter storage.SubscriptionDeleter,
	logger *zap.Logger,

	yandexAuth *yandexauth.YandexAuth,
) *Handler {
	return &Handler{
		logger:      logger,
		authClient:  authClient,
		idPManager:  idPManager,
		userSaver:   userSaver,
		subSaver:    subSaver,
		subProvider: subProvider,
		subEditor:   subEditor,
		subDeleter:  subDeleter,
		yandexAuth:  yandexAuth,
	}
}

func (h *Handler) Echo(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello, world!"))
}

// TODO: make auth and storage saving in transaction
func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.Register"

	var userCredentials domain.UserCredentials

	if err := json.NewDecoder(r.Body).Decode(&userCredentials); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to decode user credentials", zap.Error(err))
		http.Error(w, "failed to decode user credentials", http.StatusBadRequest)

		return
	}

	defer func() {
		if err := r.Body.Close(); err != nil {
			h.logger.
				With(zap.String("operation", handler)).
				Error("failed to close request body", zap.Error(err))
		}
	}()

	// save user to auth service
	registerResp, err := h.authClient.Register(
		r.Context(),
		userCredentials,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to register user", zap.Error(err))
		http.Error(w, "failed to register user", http.StatusInternalServerError)

		return
	}

	// save user to database
	_, err = h.userSaver.SaveUser(
		registerResp.Id,
		userCredentials.FullName,
		userCredentials.Surname,
		userCredentials.Email,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to save user to database", zap.Error(err))
		http.Error(w, "failed to save user to database", http.StatusInternalServerError)

		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(registerResp); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.Login"

	var loginCredentials domain.LoginRequest

	if err := json.NewDecoder(r.Body).Decode(&loginCredentials); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to decode login credentials", zap.Error(err))
		http.Error(w, "failed to decode login credentials", http.StatusBadRequest)

		return
	}

	defer func() {
		if err := r.Body.Close(); err != nil {
			h.logger.
				With(zap.String("operation", handler)).
				Error("failed to close request body", zap.Error(err))
		}
	}()

	loginResp, err := h.authClient.Login(
		r.Context(),
		loginCredentials.Email,
		loginCredentials.Password,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to login user", zap.Error(err))
		http.Error(w, "failed to login user", http.StatusInternalServerError)

		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(loginResp); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func (h *Handler) AuthWithIdentityProvider(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.AuthWithIdentityProvider"

	provider := r.FormValue("provider")

	url, err := h.idPManager.GetRedirectURL(idprovider.IdProviderType(provider))
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to get redirect url", zap.Error(err))
		http.Error(w, fmt.Sprintf("unknown provider %q", provider), http.StatusBadRequest)

		return
	}

	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func (h *Handler) AuthCallback(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.AuthCallback"

	// get user from identity provider
	user, err := h.idPManager.HandleIdPCallback(r.FormValue("code"))
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to handle idp callback", zap.Error(err))
		http.Error(w, "internal server error", http.StatusInternalServerError)

		return
	}

	// save user to database
	_, err = h.userSaver.SaveUser(
		user.Id,
		user.GivenName,
		user.FamilyName,
		user.Email,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to save user to database", zap.Error(err))
		http.Error(w, "failed to save user to database", http.StatusInternalServerError)

		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(user); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func (h *Handler) LoginWithYandex(w http.ResponseWriter, r *http.Request) {
	url := h.yandexAuth.AuthCodeURL(true)
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func (h *Handler) YandexCallback(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.YandexCallback"

	state := r.FormValue("state")
	code := r.FormValue("code")

	user, err := h.yandexAuth.GetUserInfo(state, code)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to get user info", zap.Error(err))
		http.Error(w, "failed to get user info", http.StatusInternalServerError)

		return
	}

	fmt.Printf("%+v\n", user)

	// info := struct {
	// 	Email    string `json:"email"`
	// 	Password string `json:"password"`
	// }{
	// 	Email:    user.Email,
	// 	Password: user.PsuId,
	// }

	// http.Post("/login", "application/json", bytes.NewBuffer())
}

func (h *Handler) GetSubscriptions(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.GetSubmissions"

	userId := r.URL.Query().Get("user_id")
	resultType := r.URL.Query().Get("result_type")
	offsetStr := r.URL.Query().Get("offset")
	limitStr := r.URL.Query().Get("limit")

	var offset, limit uint32
	var err error

	if offsetStr != "" {
		offset, err = strToUint32(offsetStr)
		if err != nil {
			h.logger.
				With(zap.String("operation", handler)).
				Error("failed to parse offset", zap.Error(err), zap.String("offset", offsetStr))
			offset = 0
		}
	}

	if limitStr != "" {
		limit, err = strToUint32(limitStr)
		if err != nil {
			h.logger.
				With(zap.String("operation", handler), zap.Error(err)).
				Error("failed to parse limit", zap.Error(err), zap.String("limit", limitStr))
			limit = 0
		}
	}

	subs, err := h.subProvider.GetSubscriptions(
		userId,
		storage.GetSubscriptionResultType(resultType),
		offset,
		limit,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to get subscriptions", zap.Error(err))
		http.Error(w, "failed to get subscriptions", http.StatusInternalServerError)

		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(subs); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func (h *Handler) GetSubscriptionById(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.GetSubscriptionById"

	subId := chi.URLParam(r, "sub_id")

	sub, err := h.subProvider.GetSubscriptionById(subId)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to get subscription by id", zap.Error(err))
		http.Error(w, "failed to get subscription by id", http.StatusInternalServerError)

		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(sub); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func (h *Handler) CreateSubscription(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.CreateSubscription"

	var createSubRequest domain.CreateSubscriptionRequest

	if err := json.NewDecoder(r.Body).Decode(&createSubRequest); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to decode subscription", zap.Error(err))
		http.Error(w, "failed to decode subscription", http.StatusBadRequest)

		return
	}

	defer func() {
		if err := r.Body.Close(); err != nil {
			h.logger.
				With(zap.String("operation", handler)).
				Error("failed to close request body", zap.Error(err))
		}
	}()

	subId, err := h.subSaver.SaveSubscription(
		createSubRequest.Subscription.Caption,
		createSubRequest.Subscription.Link,
		createSubRequest.Subscription.Tag,
		createSubRequest.Subscription.Category,
		createSubRequest.Subscription.Cost,
		createSubRequest.Subscription.Currency,
		createSubRequest.Subscription.FirstPay,
		createSubRequest.Subscription.Interval,
		createSubRequest.Subscription.Comment,
		createSubRequest.Subscription.Color,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to save subscription to database", zap.Error(err))
		http.Error(w, "failed to save subscription to database", http.StatusInternalServerError)

		return
	}

	if err := h.subSaver.AssignSubscriptionToUser(
		createSubRequest.UserID,
		subId,
	); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to assign subscription to user", zap.Error(err))
		http.Error(w, "failed to assign subscription to user", http.StatusInternalServerError)

		return
	}

	response := domain.SaveSubscriptionResponse{
		ID: subId,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(response); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func (h *Handler) EditSubscription(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.EditSubscription"

	subId := chi.URLParam(r, "sub_id")

	var editSubRequest domain.EditableSubscription

	if err := json.NewDecoder(r.Body).Decode(&editSubRequest); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to decode subscription", zap.Error(err))
		http.Error(w, "failed to decode subscription", http.StatusBadRequest)

		return
	}

	defer func() {
		if err := r.Body.Close(); err != nil {
			h.logger.
				With(zap.String("operation", handler)).
				Error("failed to close request body", zap.Error(err))
		}
	}()

	err := h.subEditor.EditSubscription(
		subId,
		editSubRequest.Caption,
		editSubRequest.Link,
		editSubRequest.Tag,
		editSubRequest.Category,
		editSubRequest.Cost,
		editSubRequest.Currency,
		editSubRequest.FirstPay,
		editSubRequest.Interval,
		editSubRequest.Comment,
		editSubRequest.Color,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to edit subscription", zap.Error(err))
		http.Error(w, "failed to edit subscription", http.StatusInternalServerError)

		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(editSubRequest); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func (h *Handler) DeleteSubscription(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.DeleteSubscription"

	subId := chi.URLParam(r, "sub_id")

	err := h.subDeleter.DeleteSubscription(subId)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to delete subscription", zap.Error(err))
		http.Error(w, "failed to delete subscription", http.StatusInternalServerError)

		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(subId); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func strToUint32(str string) (uint32, error) {
	const op = "strToUint32"

	uint32Value, err := strconv.ParseUint(str, 10, 32)
	if err != nil {
		return 0, fmt.Errorf("%s:%w", op, err)
	}

	return uint32(uint32Value), nil
}
