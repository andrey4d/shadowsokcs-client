# Version 0.0.1
FROM golang:1.16-alpine3.15 as builder

FROM builder as go-shadowsocks2
RUN mkdir -p /opt/go-shadowsocks2
WORKDIR /opt/go-shadowsocks2
RUN go mod init go-shadowsocks2 
RUN go get github.com/shadowsocks/go-shadowsocks2 
RUN go build github.com/shadowsocks/go-shadowsocks2

RUN go get github.com/shadowsocks/v2ray-plugin 
RUN go build github.com/shadowsocks/v2ray-plugin

FROM alpine:3.18

LABEL maintainer="andrey4d.dev@gmail.ru"
LABEL app="go-shadowsocks2"


ENV SOCKS_PORT 1080
ENV SS "ss://"

RUN apk add -U --no-cache curl iptables
WORKDIR /opt/
COPY --from=go-shadowsocks2 /opt/go-shadowsocks2/go-shadowsocks2 /opt/go-shadowsocks2/v2ray-plugin  /opt/
COPY rootfs /
CMD ./go-shadowsocks2 -c "${SS}" -verbose -socks :"${SOCKS_PORT}"