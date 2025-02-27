package http

type NotificationType string

const (
	Registration   NotificationType = "registration"
	ForgotPassword NotificationType = "forgot_password"
)

const (
	RegistrationSubject   string = "Регистрация в Wasubi"
	ForgotPasswordSubject string = "Восстановление пароля в Wasubi"
)
