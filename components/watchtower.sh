#! /bin/bash 
#Install WatchTower
echo "Installing WatchTower"

docker run -d \
--name watchtower \
-v /var/run/docker.sock:/var/run/docker.sock \
--restart=always \
--schedule 0 4 * * 0 \
 containrrr/watchtower > watchtower.log 2>&1

