#! /bin/bash 

#Install Plex
echo" Installing Plex"
echo "###############################################################"
echo "### Nvidia Hardware Transcoding Requires additional scripts ###"
echo "### located in the addons folder. #############################"
echo "###############################################################"
echo "Enter path for Plex Media"
read MEDIAPATH 
sudo mkdir $MEDIAPATH > plex.log 2>&1
echo "Enter Claim token from plex.tv/claim"
read PLEXCLAIM
docker kill plex > plex.log 2>&1
docker rm plex > plex.log 2>&1
docker run \
-d \
--name plex \
--runtime=nvidia \
--device /dev/dri:/dev/dri \
-p 32400:32400/tcp \
-p 3005:3005/tcp \
-p 8324:8324/tcp \
-p 32469:32469/tcp \
-p 1900:1900/udp \
-p 32410:32410/udp \
-p 32412:32412/udp \
-p 32413:32413/udp \
-p 32414:32414/udp \
-e TZ=America/Denver \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=compute,video,utility \
-e PLEX_CLAIM=$PLEXCLAIM \
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
-l "traefik.frontend.rule"="Host:portainer.$DOMAINNAME" \
-l "traefik.port"="32400" \
-v $DOCKERPATH/plex/database:/config \
-v /dev/shm:/transcode \
-v $MEDIAPATH:/mnt/unionfs/Media \
plexinc/pms-docker > plex.log 2>&1

docker network connect internal plex > plex.log 2>&1

