#!/bin/bash

echo "Running apt update"
sudo apt-get update -y

echo "Running apt upgrade"
sudo apt-get upgrade -y

echo "Installing nmap"
sudo apt install nmap -y

echo "Installing snap"
sudo apt install snapd -y

echo "Installing postman"
sudo snap install postman

echo "Installing Wireshark"
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark

echo "Installing curl"
sudo apt install curl -y

echo "Installing VSCode"
sudo snap install code --classic

echo "Install unzip"
sudo apt install unzip -y

echo "Installing Java"
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt update -y
sudo apt install openjdk-21-jdk -y

echo "Installing Burp Suite"
download_url="https://portswigger.net/burp/releases/download?product=community&type=jar"
wget --output-document=burpsuite_community.jar "$download_url"

echo "Installing Oracle Developer VScode extension"
runuser -l azureadmin -c 'code --install-extension Oracle.oracledevtools --force'

echo "Installing git"
sudo apt install git -y

echo "Installing python"
sudo apt install python -y
sudo apt install python3 -y

echo "Installing mitm proxy"
sudo apt install mitmproxy -y

echo "Setting up ubuntu desktop"
sudo apt install xrdp -y
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo apt install ubuntu-desktop -y
