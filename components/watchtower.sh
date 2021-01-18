#! /bin/bash 
#Install WatchTower
echo "Installing WatchTower"

docker run -d \
--name watchtower \
-v /var/run/docker.sock:/var/run/docker.sock \
--restart=always \
-e WATCHTOWER_POLL_INTERVAL=86400 \
containrrr/watchtower

