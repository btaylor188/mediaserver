#! /bin/bash
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
traefik:v1.7 

docker network connect bridge traefik 

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
thomseddon/traefik-forward-auth

docker network connect internal oauth
