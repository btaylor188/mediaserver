#### Configure Driver Blacklist ####
echo "Configuring Driver Blacklist"
echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist-nouveau.conf
echo 'options nouveau modeset=0' >> /etc/modprobe.d/blacklist-nouveau.conf
update-initramfs -u 
 
echo "#################################################"
echo "######## Please reboot before continuing ########"
echo "#################################################"