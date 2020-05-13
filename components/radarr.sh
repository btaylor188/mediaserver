#! /bin/bash 

# Install Radarr

echo "Installing Radarr"
docker kill radarr
docker rm radarr
docker run -d \
--name=radarr \
-p 127.0.0.1:7878:7878 \
-e PUID=1000 \
-e PGID=1000 \
-e HOME=/root \
-e TERM=xterm \
-e XDG_CONFIG_HOME=/config/xdg \
-e LANGUAGE=en_US.UTF-8 \
-e LANG=en_US.UTF-8 \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/radarr:/config \
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
-l "traefik.frontend.rule"="Host:radarr.$DOMAINNAME,radarr.$DOMAINNAME" \
-l "traefik.port"="7878" \
--restart=always \
linuxserver/radarr:latest
docker network connect internal radarr
