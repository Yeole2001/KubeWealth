# Stage 1: Build the binary
FROM golang:1.26-alpine AS builder 
WORKDIR /app
COPY go.mod ./ 
# Note: You likely don't have go.sum yet, so we only copy go.mod
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o transaction-service main.go

# Stage 2: Final minimal image
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/transaction-service .
EXPOSE 8080
CMD ["./transaction-service"]