ARG GOLANG_VERSION="1.19.1"

FROM golang:$GOLANG_VERSION-alpine as builder
RUN apk --no-cache add tzdata
WORKDIR /go/src/github.com/serjs/socks5
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-s' -o ./socks5

FROM alpine:latest
RUN apk --update --no-cache add curl
COPY --from=builder /go/src/github.com/serjs/socks5/socks5 /
HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost:1080/ || exit 1
ENTRYPOINT ["/socks5"]
