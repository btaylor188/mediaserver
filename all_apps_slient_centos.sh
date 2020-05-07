#! /bin/bash

#prompt for config info
echo "What is the domain name?"
read DOMAINNAME

echo "Enter your GoDaddy API Key"
read DOMAINAPIKEY

echo "Enter your GoDaddy API Secret"
read DOMAINAPISECRET

echo "Enter your Google OAuth Client ID"
read OAUTHCLIENT

echo "Enter your Google OAuth Secret"
read OAUTHSECRET

echo "Enter comma separated list of authorized users.  ie. user1@gmail.com,user2@gmail.com,"
read AUTHORIZEDUSERS

echo "Enter Certificate Contact Email Address"
read CERTCONTACT

echo "Enter path for Docker data.  ie. /mnt/docker"
read DOCKERPATH

#Prep work
mkdir $DOCKERPATH

#Install Common Tools

echo "Installing Common Tools"
yum update  > install.log 2>&1
yum install \
    zip \
	unzip \
	htop \
	screen \
	mc \
	curl \
	wget -y > install.log 2>&1

# Install Docker

echo "Installing Docker"
curl -fsSL https://get.docker.com/ | sh
systemctl enable docker --now

# Create Docker network
docker network create -d bridge --subnet=172.18.0.0/24 internal > install.log 2>&1

#Install Portainer

echo "Installing Portainer"

docker run -d \
--name=portainer  \
-p 127.0.0.1:9000:9000 \
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
portainer/portainer > install.log 2>&1
 
docker network connect internal portainer > install.log 2>&1

# Install Organizr

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
organizrtools/organizr-v2:latest > install.log 2>&1
 
docker network connect internal organizr > install.log 2>&1

#Install NZBGet

echo "Installing NZBGet"

docker run -d \
--name=nzbget \
-p 127.0.0.1:6789:6789 \
-e LC_ALL=C \
-e PUID=1000 \
-e PGID=1000 \
-e PS1=$(whoami)@$(hostname):$(pwd)$ \
-e HOME=/root \
-e TERM=xterm \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/nzbget:/config \
-v /mnt:/mnt \
-v /tmp:/tmp \
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
-l "traefik.frontend.rule"="Host:nzbget.$DOMAINNAME,nzbget.$DOMAINNAME" \
-l "traefik.port"="6789" \
--restart=always \
linuxserver/nzbget:latest > install.log 2>&1
 
docker network connect internal nzbget > install.log 2>&1

# Install Deluge

echo "Installing Deluge"

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
linuxserver/deluge > install.log 2>&1
 
docker network connect internal deluge > install.log 2>&1

# Install Radarr

echo "Installing Radarr"
docker run -d \
--name=radarr \
-p 127.0.0.1:7878:7878 \
-e PUID=1000 \
-e PGID=1000 \
-e HOME=/root \
-e TERM=xterm \
-e XDG_CONFIG_HOME=/config/xdg \
-e LANGUAGE=en_US.UTF-8 \
-e LANG=en_US.UTF-8 \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/radarr:/config \
-v /mnt:/mnt \
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
-l "traefik.frontend.rule"="Host:radarr.$DOMAINNAME,radarr.$DOMAINNAME" \
-l "traefik.port"="7878" \
--restart=always \
linuxserver/radarr:latest > install.log 2>&1
 
docker network connect internal radarr > install.log 2>&1

# Install Sonarr
echo "Installing Sonarr"
docker run -d \
--name=sonarr \
-p 127.0.0.1:8989:8989 \
-e PUID=1000 \
-e PGID=1000 \
-e HOME=/root \
-e TERM=xterm \
-e XDG_CONFIG_HOME=/config/xdg \
-e LANGUAGE=en_US.UTF-8 \
-e LANG=en_US.UTF-8 \
-e SONARR_BRANCH=master \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/sonarr:/config \
-v /mnt:/mnt \
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
-l "traefik.frontend.rule"="Host:sonarr.$DOMAINNAME,sonarr.$DOMAINNAME" \
-l "traefik.port"="8989" \
--restart=always \
linuxserver/sonarr:latest > install.log 2>&1
 
docker network connect internal sonarr > install.log 2>&1

# Install Bazarr
echo "Installing Bazarr"
 docker run -d \
--name=bazarr \
-p 127.0.0.1:6767:6767 \
-e PUID=1000 \
-e PGID=1000 \
-e HOME=/root \
-e TERM=xterm \
-e PS1=$(whoami)@$(hostname):$(pwd)\$ \
-e TZ=Etc/UTC \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/bazarr:/config \
-v /mnt:/mnt \
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
-l "traefik.frontend.rule"="Host:bazarr.$DOMAINNAME" \
-l "traefik.port"="6767" \
--restart=always \
linuxserver/bazarr:latest > install.log 2>&1

docker network connect internal bazarr > install.log 2>&1

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
jlesage/handbrake > install.log 2>&1

docker network connect internal handbrake > install.log 2>&1

# Install Speedtest
echo "Installing Speedtest"

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
adolfintel/speedtest > install.log 2>&1

docker network connect internal speedtest > install.log 2>&1

# Install LazyLibrarian
echo "Installing LazyLibrarian"
docker run -d \
--name=lazylibrarian \
-p 127.0.0.1:5299:5299 \
-e PUID=1000 \
-e PGID=1000 \
-e HOME=/root \
-e TERM=xterm \
-e LANGUAGE=en_US.UTF-8 \
-e LANG=en_US.UTF-8 \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/lazylibrarian:/config \
-v /mnt:/mnt \
-v lazybooks:/books \
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
-l "traefik.frontend.rule"="Host:lazylibrarian.$DOMAINNAME,lazylibrarian.$DOMAINNAME" \
-l "traefik.port"="5299" \
--restart=always \
linuxserver/lazylibrarian:latest > install.log 2>&1

docker network connect internal lazylibrarian > install.log 2>&1

#Install WatchTower
echo "Installing WatchTower"

docker run -d \
--name watchtower \
-v /var/run/docker.sock:/var/run/docker.sock \
 containrrr/watchtower > install.log 2>&1
 
 # Traefik

echo "Installing Traefik"
## create toml file
mkdir $DOCKERPATH/traefik
cat > $DOCKERPATH/traefik/traefik.toml << EOF1
################################################################################
insecureskipverify = true
logLevel = "WARN"
defaultEntryPoints = ["http", "https"]
[entryPoints]
[entryPoints.http]
address = ":80"
[entryPoints.http.redirect]
entryPoint = "https"
[entryPoints.https]
address = ":443"
[entryPoints.https.tls]
MinVersion = "VersionTLS12"
CipherSuites = ["TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256","TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256","TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384","TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384","TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256","TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256"]
[entryPoints.monitor]
address = ":8081"
[retry]
[acme]
acmeLogging = true
email = "$CERTCONTACT"
storage = "/etc/traefik/acme/acme.json"
entryPoint = "https"
[acme.dnsChallenge]
provider = "godaddy"
delayBeforeCheck = "60"
[[acme.domains]]
main = "$DOMAINNAME"
[[acme.domains]]
main = "*.$DOMAINNAME"
[backends]
## Cockpit Backend
[backends.cockpit]
[backends.cockpit.servers.server]
url = "https://127.0.0.1:9090"
[frontends]
## Cockpit Frontend
[frontends.cockpit]
backend = "cockpit"
passHostHeader = true
[frontends.cockpit.routes.cockpit]
rule = "Host:cockpit.$DOMAINNAME"
[docker]
endpoint = "unix:///var/run/docker.sock"
domain = "$DOMAINNAME"
watch = true
exposedbydefault = false
network = "internal"
EOF1

## Install Traefik Container
docker run -d \
--name=traefik \
-p 80:80 \
-p 443:443 \
-e PUID=1000 \
-e PGID=1000 \
-e GODADDY_API_SECRET=$DOMAINAPISECRET \
-e GODADDY_API_KEY=$DOMAINAPIKEY \
-e PROVIDER=godaddy \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/localtime:/etc/localtime \
-v $DOCKERPATH/traefik/acme:/etc/traefik/acme \
-v $DOCKERPATH/traefik:/etc/traefik \
-v traefiktmp:/tmp \
--network=internal \
--restart=always \
traefik:v1.7 > install.log 2>&1

docker network connect bridge traefik > install.log 2>&1

#Install OAuth

echo "Installing OAuth Container" 
##Generate Secret Key
SECRETKEY=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random)

##Create Container
docker run -d \
--name=oauth \
-e PUID=1000 \
-e PGID=1000 \
-e AUTH_HOST=oauth.$DOMAINNAME \
-e INSECURE_COOKIE=True \
-e WHITELIST=$AUTHORIZEDUSERS \
-e CLIENT_ID=$OAUTHCLIENT \
-e CLIENT_SECRET=$OAUTHSECRET \
-e SECRET=$SECRETKEY \
-e LIFETIME=2592000 \
-e COOKIE_DOMAIN=$DOMAINNAME \
-l traefik.backend=oauth \
-l "traefik.enable"="true" \
-l "traefik.frontend.auth.forward.address"="http://oauth:4181" \
-l "traefik.frontend.rule"="Host:oauth.$DOMAINNAME" \
-l "traefik.port"="4181" \
--restart=always \
thomseddon/traefik-forward-auth > install.log 2>&1

docker network connect internal oauth > install.log 2>&1
