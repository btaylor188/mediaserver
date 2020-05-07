#! /bin/bash 
echo "What is the domain name?"
read DOMAINNAME
echo "Enter path for Docker data.  ie. /mnt/docker"
read DOCKERPATH
#Install HandBrake
echo "Installing HandBrake"
 docker run -d \
--name=handbrake \
-p 127.0.0.1:5800:5800 \
--device /dev/dri:/dev/dri \
-e GROUP_ID=1000 \
-e USER_ID=1000 \
-e AUTOMATED_CONVERSION_PRESET=myh265 \
-e AUTOMATED_CONVERSION_FORMAT=mkv \
-e XDG_CONFIG_HOME=/config/xdg \
-e LANG=en_US.UTF-8 \
-e S6_BEHAVIOUR_IF_STAGE2_FAILS=3 \
-e S6_SERVICE_DEPS=1 \
-e APP_NAME=HandBrake \
-e APP_USER=app \
-e XDG_DATA_HOME=/config/xdg/data \
-e XDG_CONFIG_HOME=/config/xdg/config \
-e XDG_CACHE_HOME=/config/xdg/cache \
-e XDG_RUNTIME_DIR=/tmp/run/user/app \
-e DISPLAY=:0 \
-e DISPLAY_WIDTH=1280 \
-e DISPLAY_HEIGHT=768 \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/handbrake/config:/config \
-v /mnt:/mnt \
-v /mnt/docker/handbrake/watch/my265:/watch \
-v /mnt/docker/handbrake/complete:/output  \
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
--restart=always \
jlesage/handbrake
docker network create -d bridge --subnet=172.18.0.0/24 internal
docker network connect internal handbrake
