package domain

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type CreateSubscriptionRequest struct {
	UserID       string       `json:"user_id"`
	Subscription Subscription `json:"subscription"`
}
