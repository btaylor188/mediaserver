#! /bin/bash

echo "Location of watch folder?"
read WATCH
echo "Location of output folder?"
read OUTPUT

docker kill handbrake > handbrake.log 2>&1
docker rm handbrake > handbrake.log 2>&1

docker run -d -t \
--name=handbrake \
--runtime=nvidia \
-p 127.0.0.1:5800:5800 \
-v $DOCKERPATH:/config \
-v $WATCH:/watch:rw \
-v $OUTPUT:/output:rw \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=compute,video,utility \
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
--restart=always \
zocker160/handbrake-nvenc:latest > handbrake.log 2>&1

docker network connect internal handbrake > handbrake.log 2>&1
