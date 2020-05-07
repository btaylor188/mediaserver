#! /bin/bash 
echo "What is the domain name?"
read DOMAINNAME
echo "Enter path for Docker data.  ie. /mnt/docker"
read DOCKERPATH
echo "Installing Deluge
# Install Sonarr
echo "Installing Sonarr"
docker run -d \
--name=sonarr \
-p 127.0.0.1:8989:8989 \
-e PUID=1000 \
-e PGID=1000 \
-e HOME=/root \
-e TERM=xterm \
-e XDG_CONFIG_HOME=/config/xdg \
-e LANGUAGE=en_US.UTF-8 \
-e LANG=en_US.UTF-8 \
-e SONARR_BRANCH=master \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/sonarr:/config \
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
-l "traefik.frontend.rule"="Host:sonarr.$DOMAINNAME,sonarr.$DOMAINNAME" \
-l "traefik.port"="8989" \
--restart=always \
linuxserver/sonarr:latest

docker network create -d bridge --subnet=172.18.0.0/24 internal
docker network connect internal sonarr
