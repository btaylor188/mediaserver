#! /bin/bash 

docker kill nzbget
docker rm nzbget
docker run -d \
--name=nzbget \
-p 127.0.0.1:6789:6789 \
-e LC_ALL=C \
-e PUID=1000 \
-e PGID=1000 \
-e PS1=$(whoami)@$(hostname):$(pwd)$ \
-e HOME=/root \
-e TERM=xterm \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/nzbget:/config \
-v /mnt:/mnt \
-v /tmp:/tmp \
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
-l "traefik.frontend.rule"="Host:nzbget.$DOMAINNAME,nzbget.$DOMAINNAME" \
-l "traefik.port"="6789" \
--restart=always \
linuxserver/nzbget:latest
docker network connect internal nzbget
