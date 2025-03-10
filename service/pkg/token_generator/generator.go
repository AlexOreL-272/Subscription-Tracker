package tokengen

import (
	"crypto/rand"
	"encoding/base64"
)

func GenerateToken(length int) string {
	return ""
}

func GenerateURLSafeToken(length int) (string, error) {
	b := make([]byte, length)

	_, err := rand.Read(b)
	if err != nil {
		return "", err
	}

	token := base64.URLEncoding.EncodeToString(b)

	return token, nil
}
