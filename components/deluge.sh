#! /bin/bash 

echo "Installing Deluge"
docker kill deluge > deluge.log 2>&1
docker rm deluge > deluge.log 2>&1
docker run -d \
--name=deluge \
-p 127.0.0.1:8112:8112 \
-e PUID=1000 \
-e PGID=1000 \
-e HOME=/root \
-e TERM=xterm \
-e XDG_CONFIG_HOME=/config/xdg \
-e LANGUAGE=en_US.UTF-8 \
-e LANG=en_US.UTF-8 \
-e SPYTHON_EGG_CACHE=/config/plugins/.python-eggs \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/deluge:/config \
-v /mnt:/mnt \
-v  delguedownload:/download \
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
-l "traefik.frontend.rule"="Host:deluge.$DOMAINNAME" \
-l "traefik.port"="8112" \
--restart=always \
linuxserver/deluge > deluge.log 2>&1
docker network connect internal deluge > deluge.log 2>&1
