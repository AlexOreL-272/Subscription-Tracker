package emailsender

import (
	"crypto/tls"
	"fmt"

	"gopkg.in/gomail.v2"
)

type EmailSender struct {
	smtpServerHost string
	smtpServerPort int
	smtpUsername   string
	smtpPassword   string

	smtpServerAddr string
}

func New(
	smtpServerHost string,
	smtpServerPort int,
	smtpUsername string,
	smtpPassword string,
) *EmailSender {
	return &EmailSender{
		smtpServerHost: smtpServerHost,
		smtpServerPort: smtpServerPort,
		smtpUsername:   smtpUsername,
		smtpPassword:   smtpPassword,

		smtpServerAddr: fmt.Sprintf("%s:%d", smtpServerHost, smtpServerPort),
	}
}

func (s *EmailSender) Send(msg EmailMessage) error {
	message := gomail.NewMessage()

	message.SetHeader("From", msg.From)
	message.SetHeader("To", msg.To...)
	message.SetHeader("Subject", msg.Subject)
	message.SetBody(msg.ContentType, string(msg.Body))

	dialer := gomail.NewDialer(
		s.smtpServerHost,
		s.smtpServerPort,
		s.smtpUsername,
		s.smtpPassword,
	)

	dialer.TLSConfig = &tls.Config{
		InsecureSkipVerify: true,
		ServerName:         s.smtpServerAddr,
	}

	if err := dialer.DialAndSend(message); err != nil {
		return err
	}

	return nil
}
