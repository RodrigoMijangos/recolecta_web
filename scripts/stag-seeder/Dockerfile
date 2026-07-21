FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod ./
# Si el proyecto tiene dependencias go.sum, las copiamos; si no, dejamos que go mod tidy las resuelva.
RUN go mod tidy
COPY main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o seeder main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/seeder .
CMD ["./seeder"]
