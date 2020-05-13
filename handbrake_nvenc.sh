#! /bin/bash

echo "What is the domain name?"
read DOMAINNAME
echo "Enter path for Docker data.  ie. /mnt/docker"
read DOCKERPATH
echo "Location of watch folder?"
read WATCH
echo "Location of output folder?"
read OUTPUT

docker kill handbrake
docker rm handbrake

docker run -d -t \
--name=handbrake \
-p 5800:5800 \
-v $DOCKERPATH:/config \
-v $WATCH:/watch:rw \
-v $OUTPUT:/output:rw \
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
-l "traefik.frontend.rule"="Host:handbrake.$DOMAINNAME,handbrake.$DOMAINNAME" \
-l "traefik.port"="5800" \
--gpus all \
zocker160/handbrake-nvenc:latest

docker network create -d bridge --subnet=172.18.0.0/24 internal
docker network connect internal handbrake
