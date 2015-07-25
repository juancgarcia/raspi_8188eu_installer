#!/bin/bash

kernel=$(uname -r)
build=$(uname -v | awk '{print $1}')

web_forum="https://www.raspberrypi.org/forums/viewtopic.php?t=62371"
dropbox_file=`curl $web_forum | sed 's:<br:\r\n<br:g' | grep "${kernel}.*${build}.*.tar.gz" | awk '{print $NF}' | tr -d "[:space:][:cntrl:]"`

wget https://dl.dropboxusercontent.com/u/80256631/$dropbox_file
tar xzf $dropbox_file
rm $dropbox_file

module_bin="8188eu.ko"
module_dir="/lib/modules/$kernel/kernel/drivers/net/wireless"

echo "sudo cp 8188eu.conf /etc/modprobe.d/."
sudo cp 8188eu.conf /etc/modprobe.d/.

echo "sudo install -p -m 644 $module_bin $module_dir"
sudo install -p -m 644 $module_bin $module_dir
echo "sudo depmod $kernel"
sudo depmod $kernel
rm 8188eu*

echo
echo "Reboot to run the driver."
echo
echo "If you have already configured your wifi it should start up and connect to your"
echo "wireless network."
echo
echo "If you have not configured your wifi you will need to do that to enable the wifi."
