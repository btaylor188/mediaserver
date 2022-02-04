#! /bin/bash 

# Install Tdarr

echo "Installing Tdarr"
docker kill tdarr > tdarr.log 2>&1
docker rm trdarr > tdarr.log 2>&1

docker run -d \
--name=tdarr_server \
-v $DOCKERPATH/tdarr/server:/app/server \
-v $DOCKERPATH/tdarr/configs:/app/configs \
-v $DOCKERPATH/tdarr/logs:/app/logs \
-v /mnt/Media:/media \
-v /temp:/temp \
-e "serverIP=10.100.100.5" \
-e "serverPort=8266" \
-e "webUIPort=8265" \
-p 8265:8265 \
-p 8266:8266 \
-e "TZ=America/Denver" \
-e PUID=1000 \
-e PGID=1000 \
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
-l "traefik.frontend.rule"="Host:tdarr.$DOMAINNAME,tdarr.$DOMAINNAME" \
-l "traefik.port"="8265" \
--log-opt max-size=10m \
--log-opt max-file=5 \
--restart=always \
haveagitgat/tdarr

docker run -d \
--name=tdarr_node \
-v $DOCKERPATH/tdarr/configs:/app/configs \
-v $DOCKERPATH/tdarr/logs:/app/logs \
-v /mnt/Media:/media \
-v /temp:/temp \
-e "nodeID=MyFirstTdarrNode" \
-e "nodeIP=10.100.100.5" \
-e "nodePort=8267" \
-e "serverIP=10.100.100.5" \
-e "serverPort=8266" \
-p 8267:8267 \
-e "TZ=America/Denver" \
-e PUID=1000 \
-e PGID=1000 \
-e "NVIDIA_DRIVER_CAPABILITIES=all" \
-e "NVIDIA_VISIBLE_DEVICES=all" \
--gpus=all \
--device=/dev/dri:/dev/dri \
--log-opt max-size=10m \
--log-opt max-file=5 \
--restart=always \
haveagitgat/tdarr_node
docker network connect internal tdarr_server > tdarr.log 2>&1
docker network connect internal tdarr_node > tdarr.log 2>&1







