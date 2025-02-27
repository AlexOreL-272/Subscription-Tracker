package htmlgenerator

import (
	"html/template"
	"path/filepath"
	"strings"
)

type EmailHTMLGenerator interface {
	CreateRegistrationEmailHTML(token string) (string, error)
}

type EmailGenerator struct {
	registrationTemplatePath string
}

func New(
	templatesPath string,
) *EmailGenerator {
	return &EmailGenerator{
		registrationTemplatePath: filepath.Join(templatesPath, "registration", "registration.html"),
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
