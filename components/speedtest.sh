#! /bin/bash 

# Install Speedtest
echo "Installing Speedtest"
docker kill speedtest > speedtest.log 2>&1
docker rm speedtest > speedtest.log 2>&1
docker run -d \
--name=speedtest \
-p 127.0.0.1:8223:8223 \
-e PUID=1000 \
-e PGID=1000 \
-e TITLE=$DOMAINNAME \
-e WEBPORT=8223 \
-v /var/run/docker.sock:/var/run/docker.sock \
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
-l "traefik.frontend.rule"="Host:speedtest.$DOMAINNAME,speedtest.$DOMAINNAME" \
-l "traefik.port"="8223" \
--restart=always \
adolfintel/speedtest > speedtest.log 2>&1
docker network connect internal speedtest > speedtest.log 2>&1
