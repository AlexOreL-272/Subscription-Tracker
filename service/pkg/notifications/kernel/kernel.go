package kernel

import (
	"github.com/AlexOreL-272/Subscription-Tracker/pkg/notifications"
	email "github.com/AlexOreL-272/Subscription-Tracker/pkg/notifications/senders/email"
	"go.uber.org/zap"
)

type Sender struct {
	emailSender *email.EmailSender

	senderCredentials SenderCredentials
	logger            *zap.Logger
}

type KernelConfig struct {
	email *EmailConfig
}

type EmailConfig struct {
	SmtpServerHost string
	SmtpServerPort int
	SmtpUsername   string
	SmtpPassword   string
}

type SenderCredentials struct {
	SenderEmail    string
	SenderNickname string
}

func New(
	cfg KernelConfig,
	creds SenderCredentials,
	logger *zap.Logger,
) *Sender {
	return &Sender{
		logger: logger,
		emailSender: email.New(
			cfg.email.SmtpServerHost,
			cfg.email.SmtpServerPort,
			cfg.email.SmtpUsername,
			cfg.email.SmtpPassword,
		),
		senderCredentials: creds,
	}
}

func (s *Sender) Send(
	method notifications.NotificationMethod,
	to []string,
	body []byte,
	opts notifications.ParameterTable,
) error {
	switch method {
	case notifications.Email:
		return s.sendEmail(to, body, opts)
	default:
		return notifications.ErrUnknownMethod
	}
}

func (s *Sender) sendEmail(
	to []string,
	body []byte,
	opts notifications.ParameterTable,
) error {
	const op = "kernel.sendEmail"

	s.logger.
		With(zap.String("op", op)).
		Info("Sending email notification to", zap.Strings("to", to))

	subject, ok := opts[notifications.Subject]
	if !ok {
		s.logger.
			With(zap.String("op", op)).
			Warn("Subject not provided")

		subject = ""
	}

	contentType, ok := opts[notifications.ContentType]
	if !ok {
		s.logger.
			With(zap.String("op", op)).
			Warn("Content-Type not provided, using text/plain")

		contentType = "text/plain"
	}

	emailMessage := email.EmailMessage{
		From:        s.senderCredentials.SenderEmail,
		To:          to,
		Subject:     subject.(string),
		ContentType: contentType.(string),
		Body:        body,
	}

	return s.emailSender.Send(emailMessage)
}
