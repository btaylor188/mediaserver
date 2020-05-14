#! /bin/bash
####### Define Variables ######
echo "What is the domain name?"
read DOMAINNAME

echo "Enter path for Docker data.  ie. /mnt/docker"
read DOCKERPATH
sudo mkdir $DOCKERPATH

export DOMAINNAME=$DOMAINNAME
export DOCKERPATH=$DOCKERPATH

###############################


##########   Docker ###########
while true; do
    read -p "Install Docker?" yn
    case $yn in
        [Yy]* ) sh ./components/docker.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### Watchtower #############
sh ./components/watchtower.sh

###############################

######### Traefik #############

while true; do
    read -p "Install Traefik?" yn
    case $yn in
        [Yy]* ) sh ./components/traefik.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################



######### Portainer #############

while true; do
    read -p "Install Portainer?" yn
    case $yn in
        [Yy]* ) sh ./components/portainer.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### Plex #############

while true; do
    read -p "Install Plex?" yn
    case $yn in
        [Yy]* ) sh ./components/plex.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### NZBGet ##############

while true; do
    read -p "Install NZBGet?" yn
    case $yn in
        [Yy]* ) sh ./components/nzbget.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### Deluge ##############

while true; do
    read -p "Install Deluge?" yn
    case $yn in
        [Yy]* ) sh ./components/deluge.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### Organizr ############

while true; do
    read -p "Install Organizr?" yn
    case $yn in
        [Yy]* ) sh ./components/organizr.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### Sonar ###############

while true; do
    read -p "Install Sonarr?" yn
    case $yn in
        [Yy]* ) sh ./components/sonarr.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### Radarr ##############

while true; do
    read -p "Install Radarr?" yn
    case $yn in
        [Yy]* ) sh ./components/radarr.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### Bazarr ##############

while true; do
    read -p "Install Bazarr?" yn
    case $yn in
        [Yy]* ) sh ./components/bazarr.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

###### Lazy Librarian #########

while true; do
    read -p "Install Lazy Librarian?" yn
    case $yn in
        [Yy]* ) sh ./components/lazylibrarian.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######## Speedtest ############

while true; do
    read -p "Install Speedtest?" yn
    case $yn in
        [Yy]* ) sh ./components/speedtest.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

######### Handbrake w/ NVENC #############

while true; do
    read -p "Install Handbrake?" yn
    case $yn in
        [Yy]* ) sh ./components/handbrake.sh ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###############################

echo "############################"
echo "#######   All Done   #######"
echo "############################"
