FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o full-cycle -ldflags="-s -w"

FROM scratch

COPY --from=builder /app/full-cycle /full-cycle

CMD ["./full-cycle"]