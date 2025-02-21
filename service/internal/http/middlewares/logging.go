package httpmiddleware

import (
	"net/http"
	"time"

	"go.uber.org/zap"
)

type LoggingInterceptor struct {
	logger *zap.Logger
}

func NewLoggingInterceptor(logger *zap.Logger) *LoggingInterceptor {
	return &LoggingInterceptor{
		logger: logger,
	}
}

func (i *LoggingInterceptor) Intercept(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		i.logger.Info(
			"Starting",
			zap.String("method", r.Method),
			zap.String("path", r.URL.Path),
		)

		startTime := time.Now()

		next.ServeHTTP(w, r)

		i.logger.Info(
			"Completed",
			zap.String("method", r.Method),
			zap.String("path", r.URL.Path),
			zap.Duration("duration", time.Since(startTime)),
		)
	})
}
