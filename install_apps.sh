#!/bin/bash

USERNAME=$1
PASSWORD=$2

if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
  echo "ERROR: USERNAME or PASSWORD is empty."
  exit 1
fi

sudo adduser -m "$USERNAME"
echo "$USERNAME:$PASSWORD" | sudo chpasswd

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

echo "Installing jq"
sudo apt install jq -y

echo "installing passwd"
sudo apt install passwd -y

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
sudo mkdir -p /opt/burp
sudo mv burpsuite_community.jar /opt/burp/
echo -e '#!/bin/bash\njava -jar /opt/burp/burpsuite_community.jar' | sudo tee /usr/local/bin/burp
sudo chmod +x /usr/local/bin/burp
cat <<EOF | sudo tee /usr/share/applications/burp.desktop
[Desktop Entry]
Name=Burp Suite Community
Exec=java -jar /opt/burp/burpsuite_community.jar
Icon=utilities-terminal
Type=Application
Categories=Utility;
EOF
export VAULT_ADDR=http://172.200.72.230:8200

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

echo "Setting op boa cli"
wget https://github.com/openbao/openbao/releases/download/v2.2.2/bao_2.2.2_linux_amd64.deb
sudo dpkg -i bao_2.2.2_linux_amd64.deb

echo "Adding vault address"
# Waarde voor VAULT_ADDR
VAULT_ADDR_VALUE="http://172.200.72.230:8200"
BASHRC_FILE="$HOME/.bashrc"

# Check of de regel al bestaat
if grep -q "export VAULT_ADDR=" "$BASHRC_FILE"; then
    echo "VAULT_ADDR staat al in $BASHRC_FILE. Bijwerken..."
    # Update de bestaande regel
    sed -i "s|export VAULT_ADDR=.*|export VAULT_ADDR='$VAULT_ADDR_VALUE'|" "$BASHRC_FILE"
else
    echo "export VAULT_ADDR='$VAULT_ADDR_VALUE'" >> "$BASHRC_FILE"
    echo "VAULT_ADDR toegevoegd aan $BASHRC_FILE"
fi

# Herladen
echo "Herladen van $BASHRC_FILE..."
source "$BASHRC_FILE"

# Controleren
echo "Ingestelde VAULT_ADDR: $VAULT_ADDR"

sudo usermod -aG sudo,video,audio,ssl-cert,xrdp $USERNAME
sudo echo "startxfce4" > /home/$USERNAME/.xsession
sudo chmod +x /home/$USERNAME/.xsession
sudo chown $USERNAME:$USERNAME /home/$USERNAME/.xsession
sudo runuser -l $USERNAME -c 'touch ~/.Xauthority && chmod 600 ~/.Xauthority'
sudo systemctl restart xrdp

