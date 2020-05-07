#! /bin/bash 
echo "What is the domain name?"
read DOMAINNAME
echo "Enter path for Docker data.  ie. /mnt/docker"
read DOCKERPATH
# Install Bazarr
echo "Installing Bazarr"
 docker run -d \
--name=bazarr \
-p 127.0.0.1:6767:6767 \
-e PUID=1000 \
-e PGID=1000 \
-e HOME=/root \
-e TERM=xterm \
-e PS1=$(whoami)@$(hostname):$(pwd)\$ \
-e TZ=Etc/UTC \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/bazarr:/config \
-v /mnt:/mnt \
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
-l "traefik.frontend.rule"="Host:bazarr.$DOMAINNAME" \
-l "traefik.port"="6767" \
--restart=always \
linuxserver/bazarr:latest
docker network create -d bridge --subnet=172.18.0.0/24 internal
docker network connect internal bazarr
