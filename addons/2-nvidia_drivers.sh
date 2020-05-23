### Driver Install ##
echo "Installing Nvidia Driver 440.82"

### Software requirements ###
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install gcc binutils make linux-source nvidia-docker2 nvidia-container-runtime -y
sudo apt install linux-headers-$(uname -r) -yum
sudo yum install kernel-devel dkms gcc make perl bin utils linux-source nvidia-docker2 nvidia-container-runtime -y


### Download and install drivers ###
sudo rm -rf /opt/nvidia
sudo mkdir /opt/nvidia && cd /opt/nvidia
sudo wget https://international.download.nvidia.com/XFree86/Linux-x86_64/440.82/NVIDIA-Linux-x86_64-440.82.run
sudo chmod +x /opt/nvidia/NVIDIA-Linux-x86_64-440.82.run
sudo ./NVIDIA-Linux-x86_64-440.82.run

echo "#################################################"
echo "########## Please reboot to complete ############"
echo "#################################################"
