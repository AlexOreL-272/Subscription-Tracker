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
	confirmationFilePath := filepath.Join(s.templatesPath, "registration", "confirmation.html")

	http.ServeFile(w, r, confirmationFilePath)
}

func (s *StaticFileHandler) ServeSuccessVerificationPage(w http.ResponseWriter, r *http.Request) {
	confirmationFilePath := filepath.Join(s.templatesPath, "registration", "confirmed.html")

	http.ServeFile(w, r, confirmationFilePath)
}
