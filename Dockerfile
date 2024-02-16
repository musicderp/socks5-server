ARG GOLANG_VERSION="1.19.1"

FROM golang:$GOLANG_VERSION-alpine as builder
RUN apk --no-cache add tzdata
WORKDIR /go/src/github.com/serjs/socks5
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-s' -o ./socks5

FROM alpine:latest
RUN apk --update --no-cache add curl
COPY --from=builder /go/src/github.com/serjs/socks5/socks5 /
HEALTHCHECK --interval=1m --timeout=10s --retries=3 CMD curl -x socks5://localhost:1080 -U $PROXY_USER:$PROXY_PASSWORD ifconfig.me || exit 1
ENTRYPOINT ["/socks5"]
