#!/usr/bin/env bash
. "$HOME/.cargo/env"
# export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo aptitude -y safe-upgrade
sudo apt-get --with-new-pkgs -y upgrade -o APT::Get::Always-Include-Phased-Updates=true
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y autoclean
sudo snap refresh
sudo do-release-upgrade
#sudo do-release-upgrade -d 
rustup self update
rustup update
sudo dmidecode -s bios-version
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo fwupdmgr update
tldr --update
tail -n 10  /var/log/ufw.log
