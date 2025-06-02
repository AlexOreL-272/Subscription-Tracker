package htmlgenerator

import (
	"html/template"
	"path/filepath"
	"strings"
)

type EmailHTMLGenerator interface {
	CreateRegistrationEmailHTML(token string) (string, error)
	CreateForgotPasswordEmailHTML(token string) (string, error)
}

type EmailGenerator struct {
	registrationTemplatePath   string
	forgotPasswordTemplatePath string
}

func New(
	templatesPath string,
) *EmailGenerator {
	return &EmailGenerator{
		registrationTemplatePath:   filepath.Join(templatesPath, "registration", "registration.html"),
		forgotPasswordTemplatePath: filepath.Join(templatesPath, "forgot_password", "forgot_password.html"),
	}
}

func (e *EmailGenerator) CreateRegistrationEmailHTML(token string) (string, error) {
	tmpl, err := template.ParseFiles(e.registrationTemplatePath)
	if err != nil {
		return "", err
	}

	var body strings.Builder
	if err := tmpl.Execute(&body, map[string]string{
		"Token": token,
	}); err != nil {
		return "", err
	}

	return body.String(), nil
}

func (e *EmailGenerator) CreateForgotPasswordEmailHTML(token string) (string, error) {
	tmpl, err := template.ParseFiles(e.forgotPasswordTemplatePath)
	if err != nil {
		return "", err
	}

	var body strings.Builder
	if err := tmpl.Execute(&body, map[string]string{
		"Token": token,
	}); err != nil {
		return "", err
	}

	return body.String(), nil
}
