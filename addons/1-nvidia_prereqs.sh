#### Configure Driver Blacklist ####
echo "Configuring Driver Blacklist"
sudo echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist-nouveau.conf
sudo echo 'options nouveau modeset=0' >> /etc/modprobe.d/blacklist-nouveau.conf
sudo echo 'blacklist vga16fb' >> /etc/modprobe.d/blacklist-nouveau.conf
sudo echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist-nouveau.conf
sudo echo 'blacklist rivafb' >> /etc/modprobe.d/blacklist-nouveau.conf
sudo echo 'blacklist nvidiafb' >> /etc/modprobe.d/blacklist-nouveau.conf
sudo echo 'blacklist rivatv' >> /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u 
 
echo "#################################################"
echo "######## Please reboot before continuing ########"
echo "#################################################"