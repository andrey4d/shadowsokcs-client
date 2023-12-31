## go-shadowsocks2
```url
https://github.com/shadowsocks/go-shadowsocks2/tree/master
```
### BUILD
```shell
docker-compose --profile client build
```
Multi ARCH build
```shell
docker buildx create --name second_builder --use --bootstrap
docker buildx build --push -t registry.home.local/registry.home.local/go-shadow:v0.0.1  --platform linux/amd64,linux/arm64 ./build 
docker buildx rm second_builder 
```
OR
```shell
#!/bin/sh

VERSION="v0.0.1"
IMAGE_NAME="registry.home.local/go-shadow"

docker build  --platform linux/arm64 --network host -t ${IMAGE_NAME}:${VERSION}-arm64 build
docker build  --platform linux/amd64 --network host -t ${IMAGE_NAME}:${VERSION}-amd64 build

docker push ${IMAGE_NAME}:${VERSION}-arm64 
docker push ${IMAGE_NAME}:${VERSION}-amd64

docker manifest create ${IMAGE_NAME}:${VERSION} --amend ${IMAGE_NAME}:${VERSION}-arm64 --amend ${IMAGE_NAME}:${VERSION}-amd64
docker manifest push ${IMAGE_NAME}:${VERSION}

```
### RUN
#### Edit .env 
Copy .env.sample to .env and edit it
```env
METHOD=AEAD_CHACHA20_POLY1305
SHADOW_SERVER=YOUR.PROXY.net   
SHADOW_PASSWORD=PASSWORD
SHADOW_PORT=9000

PLUGIN_NAME=v2ray-plugin
PLUGIN_OPTS=tls;${SHADOW_SERVER};path=/;mux=0

# LOCAL SOCKS5 server port
SOCKS_PORT=1080

# TUNNEL
REMOTE_HOST=YOUR.TUNNEL.HOST.net
REMOTE_PORT=443
LOCAL_PORT=80443

# REDIRECT
IP4_REDIR_PORT=1082
IP6_REDIR_PORT=1083
```
#### client with SOCKS5 
```shell
docker-compose --profile client up --force-recreate
```
#### client + v2ray plugin with SOCKS5 
```shell
docker-compose --profile client-v2ray up --force-recreate
```
#### tunnel with SOCKS5 
```shell
docker-compose --profile tunnel up --force-recreate
```
#### redirect all traffick with SOCKS5 
```shell
docker-compose --profile redir up --force-recreate
```

