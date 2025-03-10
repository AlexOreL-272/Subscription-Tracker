package pswreset

import (
	"context"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth"
	htmlgenerator "github.com/AlexOreL-272/Subscription-Tracker/internal/html_generator"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/storage"
	ctxerror "github.com/AlexOreL-272/Subscription-Tracker/pkg/context_error"
	"github.com/AlexOreL-272/Subscription-Tracker/pkg/notifications"
)

const (
	forgotPasswordSubject string = "Восстановление пароля в Wasubi"
)

type PasswordResetManager struct {
	ticketManager storage.PasswordResetter
	authManager   auth.Auth

	htmlGenerator      htmlgenerator.EmailHTMLGenerator
	notificationSender notifications.NotificationSender
}

func New(
	ticketManager storage.PasswordResetter,
	authManager auth.Auth,

	htmlGenerator htmlgenerator.EmailHTMLGenerator,
	notificationSender notifications.NotificationSender,
) *PasswordResetManager {
	return &PasswordResetManager{
		ticketManager: ticketManager,
		authManager:   authManager,

		htmlGenerator:      htmlGenerator,
		notificationSender: notificationSender,
	}
}

func (m *PasswordResetManager) RequestPasswordReset(
	ctx context.Context,
	email string,
) error {
	const op = "pswdreset.PasswordResetManager.RequestPasswordReset"

	// create ticket in ticket manager
	token, err := m.ticketManager.CreatePasswordResetTicket(ctx, email)
	if err != nil {
		return ctxerror.New(op, err)
	}

	// create HTML email page
	emailHTML, err := m.htmlGenerator.CreateForgotPasswordEmailHTML(token)
	if err != nil {
		return ctxerror.New(op, err)
	}

	// send email
	if err := m.notificationSender.Send(
		notifications.Email,
		[]string{email},
		[]byte(emailHTML),
		notifications.ParameterTable{
			notifications.Subject:     forgotPasswordSubject,
			notifications.ContentType: "text/html",
		},
	); err != nil {
		return ctxerror.New(op, err)
	}

	return nil
}

func (m *PasswordResetManager) ResetPassword(
	ctx context.Context,
	token, newPassword string,
) error {
	const op = "pswdreset.PasswordResetManager.ResetPassword"

	// validate token
	email, err := m.validatePasswordResetToken(ctx, token)
	if err != nil {
		return ctxerror.New(op, err)
	}

	// reset password
	if err := m.authManager.ResetPassword(ctx, email, newPassword); err != nil {
		return ctxerror.New(op, err)
	}

	return nil
}

func (m *PasswordResetManager) validatePasswordResetToken(
	ctx context.Context,
	token string,
) (string, error) {
	const op = "pswdreset.PasswordResetManager.ValidatePasswordResetToken"

	// validate token
	email, err := m.ticketManager.ValidatePasswordResetTicket(ctx, token)
	if err != nil {
		return "", ctxerror.New(op, err)
	}

	return email, nil
}
