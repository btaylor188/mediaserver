echo "What is the domain name?"
read DOMAINNAME
echo "Enter path for Docker data.  ie. /mnt/docker"
read DOCKERPATH
echo "Installing Organizr"
docker run -d \
--name=organizr \
-p 127.0.0.1:8040:80 \
-e PUID=1000 \
-e PGID=1000 \
-e PS1=$(whoami)@$(hostname):$(pwd)$ \
-e HOME=/root \
-e TERM=xterm \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/organizr:/config \
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
-l "traefik.frontend.headers.frameDeny"="true" \
-l "traefik.frontend.rule"="Host:organizr.$DOMAINNAME,$DOMAINNAME" \
-l "traefik.port"="80" \
--restart=always \
organizrtools/organizr-v2:latest
