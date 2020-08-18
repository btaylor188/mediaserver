#! /bin/bash

### Functions ##
function pause(){
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}


### Driver Install ##
echo "Installing Nvidia Driver 440.82"

### Software requirements ###
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install gcc binutils make linux-source pve-headers nvidia-docker2 nvidia-container-runtime -y
sudo apt install linux-headers-$(uname -r) -yum
sudo apt install pve-headers -y
sudo apt-get install -y libglvnd-dev


### Download and install drivers ###
sudo rm -rf /opt/nvidia
sudo mkdir /opt/nvidia && cd /opt/nvidia
sudo wget https://international.download.nvidia.com/XFree86/Linux-x86_64/440.82/NVIDIA-Linux-x86_64-440.82.run
sudo wget http://download.proxmox.com/debian/pve/dists/buster/pvetest/binary-amd64/pve-headers-$(uname -r)_$(uname -r | perl -pe '($_)=/([0-9]+([.-][0-9]+)+)/')_amd64.deb
sudo dpkg -i pve-headers-$(uname -r)_$(uname -r | perl -pe '($_)=/([0-9]+([.-][0-9]+)+)/')_amd64.deb
sudo chmod +x /opt/nvidia/NVIDIA-Linux-x86_64-440.82.run
sudo ./NVIDIA-Linux-x86_64-440.82.run --kernel-source-path /usr/src/linux-headers-$(uname -r)/ --glvnd-egl-config-path /usr/include/glvnd

echo "#################################################"
echo "########## Please reboot to complete ############"
echo "#################################################"
