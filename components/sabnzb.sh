#! /bin/bash 

docker kill sabnzbd > sabnzbd.log 2>&1
docker rm sabnzbd > sabnzbd.log 2>&1
docker run -d \
--name=sabnzbd \
-p 127.0.0.1:8080:8080 \
-e LC_ALL=C \
-e PUID=1000 \
-e PGID=1000 \
-e PS1=$(whoami)@$(hostname):$(pwd)$ \
-e HOME=/root \
-e TERM=xterm \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/sabnzbd:/config \
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
-l "traefik.frontend.rule"="Host:sabnzbd.$DOMAINNAME,sabnzbd.$DOMAINNAME" \
-l "traefik.port"="8080" \
--restart=always \
linuxserver/sabnzbd:latest > sabnzbd.log 2>&1
docker network connect internal sabnzbd > sabnzbd.log 2>&1
