package http

import (
	"net/http"
	"path/filepath"
)

type StaticFileHandler struct {
	templatesPath string
}

func NewStaticFileHandler(
	templatesPath string,
) *StaticFileHandler {
	return &StaticFileHandler{
		templatesPath: templatesPath,
	}
}

func (s *StaticFileHandler) ServeVerifyEmailPage(w http.ResponseWriter, r *http.Request) {
	confirmationFilePath := filepath.Join(s.templatesPath, "verify_email", "verify_email.html")

	http.ServeFile(w, r, confirmationFilePath)
}

func (s *StaticFileHandler) ServeSuccessVerificationPage(w http.ResponseWriter, r *http.Request) {
	confirmationFilePath := filepath.Join(s.templatesPath, "success_verification", "success_verification.html")

	http.ServeFile(w, r, confirmationFilePath)
}

func (s *StaticFileHandler) ServeForgotPasswordPage(w http.ResponseWriter, r *http.Request) {
	confirmationFilePath := filepath.Join(s.templatesPath, "reset_password", "reset_password.html")

	http.ServeFile(w, r, confirmationFilePath)
}

func (s *StaticFileHandler) ServeSuccessResetPage(w http.ResponseWriter, r *http.Request) {
	confirmationFilePath := filepath.Join(s.templatesPath, "reset_password", "success_reset.html")

	http.ServeFile(w, r, confirmationFilePath)
}
