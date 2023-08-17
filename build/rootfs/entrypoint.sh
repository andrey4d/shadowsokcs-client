#!/bin/sh

SHADOW_SERVER=${SHADOW_SERVER:-"127.0.0.1"}
SOCKS_PORT=${SOCKS_PORT:-"1080"}
IP4_REDIR_PORT=${IP4_REDIR_PORT:-"1082"}
IP6_REDIR_PORT=${IP6_REDIR_PORT:-"1083"}
SS=${SS:-"ss://chacha20-ietf-poly1305:<PASSWORD>@shadowhost:9002"}

iptables -t nat -N SHADOWSOCKS
iptables -t nat -A SHADOWSOCKS -d ${SHADOW_SERVER} -j RETURN

iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports ${IP4_REDIR_PORT}

iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS
iptables -t nat -I PREROUTING -p tcp -j SHADOWSOCKS

/opt/go-shadowsocks2 -c "${SS}" -verbose -socks :"${SOCKS_PORT}" -redir :"${IP4_REDIR_PORT}" -redir6 :"${IP6_REDIR_PORT}"