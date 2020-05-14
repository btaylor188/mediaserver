### Driver Install ##
echo "Installing Nvidia Driver 440.82"

### Software requirements ###
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install gcc binutils make linux-source pve-headers linux-headers-$(uname -r) nvidia-docker2 nvidia-container-runtime -y
sudo yum install kernel-devel dkms gcc cc make perl bin utils linux-source nvidia-docker2 nvidia-container-runtime -y


### Download and install drivers ###
sudo mkdir /opt/nvidia && cd /opt/nvidia
wget https://international.download.nvidia.com/XFree86/Linux-x86_64/440.82/NVIDIA-Linux-x86_64-440.82.run
chmod +x /opt/nvidia/NVIDIA-Linux-x86_64-440.82.run
./NVIDIA-Linux-x86_64-440.82.run

echo "#################################################"
echo "########## Please reboot to complete ############"
echo "#################################################"
