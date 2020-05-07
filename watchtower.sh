#! /bin/bash 
#Install WatchTower
echo "Installing WatchTower"

docker run -d \
--name watchtower \
-v /var/run/docker.sock:/var/run/docker.sock \
 containrrr/watchtower
