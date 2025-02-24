FROM golang:1.23 AS builder
WORKDIR /app

COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o main cmd/main.go

FROM debian:bullseye-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends upx && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/main /app/main

RUN upx /app/main

FROM scratch
COPY --from=runtime /app/main /main
ENV CONFIG_PATH=/opt/wasubi/configs/service/config.yaml

CMD ["/main"]