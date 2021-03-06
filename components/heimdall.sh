#! /bin/bash 

echo "Installing Heimdall"
docker kill heimdall > heimdall.log 2>&1
docker rm heimdall > heimdall.log 2>&1
docker run -d \
--name=heimdall \
-p 127.0.0.1:8050:80 \
-e PUID=1000 \
-e PGID=1000 \
-e PS1=$(whoami)@$(hostname):$(pwd)$ \
-e HOME=/root \
-e TERM=xterm \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/heimdall:/config \
-l "traefik.enable"="true" \
-l "traefik.frontend.auth.forward.address"="http://oauth:4181" \
-l "traefik.frontend.headers.SSLHost"="$DOMAINNAME" \
-l "traefik.frontend.headers.SSLRedirect"="true" \
-l "traefik.frontend.headers.STSIncludeSubdomains"="true" \
-l "traefik.frontend.headers.STSPreload"="true" \
-l "traefik.frontend.headers.STSSeconds"="315360000" \
-l "traefik.frontend.headers.browserXSSFilter"="true" \
-l "traefik.frontend.headers.contentTypeNosniff"="true" \
-l "traefik.frontend.headers.customResponseHeaders"="X-Robots-Tag:noindex,nofollow,nosnippet,noarchive,notranslate,noimageindex" \
-l "traefik.frontend.headers.forceSTSHeader"="true" \
-l "traefik.frontend.headers.frameDeny"="true" \
-l "traefik.frontend.rule"="Host:heimdall.$DOMAINNAME" \
-l "traefik.port"="80" \
--restart=always \
ghcr.io/linuxserver/heimdall > heimdall.log 2>&1
docker network connect internal heimdall > heimdall.log 2>&1