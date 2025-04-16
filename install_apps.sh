#!/bin/bash

echo "Running apt update"
sudo apt-get update -y

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
sudo apt install openjdk-11-jdk -y


latest_version=$(curl -s https://portswigger.net/burp/releases/community | grep -oP 'version=\K[\d.]+(?=")' | head -n 1)
download_url="https://portswigger.net/burp/releases/download?product=community&version=$latest_version&type=jar"
echo "Installing Burp Suite Community Edition version $latest_version..."
wget --output-document=burpsuite_community.jar "$download_url"

echo "Installing Oracle Developer VScode extension"
code --install-extension Oracle.oracledevtools --force --no-sandbox --user-data-dir
