#! /bin/bash 

# Install Overseerr

echo "Installing Overseerr"
docker kill overseerr > overseerr.log 2>&1
docker rm overseerr > overseerr.log 2>&1
docker run -d \
  --name=overseerr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/Denver \
  -p 127.0.0.1:5055:5055 \
  -v -v $DOCKERPATH/overseerr/config:/config \
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
-l "traefik.frontend.rule"="Host:overseerr.$DOMAINNAME,overseerr.$DOMAINNAME" \
-l "traefik.port"="5055" \
  --restart unless-stopped \
  lscr.io/linuxserver/overseerr