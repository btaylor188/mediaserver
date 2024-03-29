#! /bin/bash 

echo "Installing Portainer"
docker kill portainer > portainer.log 2>&1
docker rm portainer > portainer.log 2>&1
docker run -d \
--name=portainer  \
-p 9000:9000 \
--privileged \
--entrypoint="/portainer" \
-e PUID=1000 \
-e PGID=1000 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $DOCKERPATH/portainer/data:/data \
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
-l "traefik.port"="9000" \
--restart=always \
portainer/portainer-ce > portainer.log 2>&1
docker network connect internal portainer > portainer.log 2>&1
