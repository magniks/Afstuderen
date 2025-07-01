#!/bin/bash

USERNAME=$1
PASSWORD=$2

useradd -m "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

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

echo "Installing certs"
sudo apt install ca-certificates -y

echo "Installing gnupg"
sudo apt install gnupg -y

echo "Installing lsb-release"
sudo apt install lsb-release -y

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

echo "adding docker gpg"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "adding docker repo"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "installing docker"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Installing Oracle Developer VScode extension"
runuser -l "$USERNAME" -c 'code --install-extension Oracle.oracledevtools --force'

echo "Installing git"
sudo apt install git -y

echo "Installing python"
sudo apt install python -y
sudo apt install python3 -y
sudo apt install python3-pip -y
pip install oracledb

echo "Installing mitm proxy"
sudo apt install mitmproxy -y

echo "Setting up ubuntu desktop"
sudo apt install xrdp -y
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo apt install ubuntu-desktop -y

echo "install pentesttools"
sudo git clone https://x-token-auth:ATCTT3xFfGN0eC-nRrpwtw90xTakZi6E0iwiwRF-MLUJ0OEyVDKQvod05eSwqvi3mw4wc4e_iPc4UD1m2yZIkbadVVlfXgRdCtWm3qKNgB7VFpvhzjvrEEjIYjPWAxnLmzxJ3DM6_JgY2VrSc91q-UfvrXZDc6R5uB2u88rLMAtyYquuBVBf11U=B6AA6BC9@bitbucket.org/flod-marnix/pentestscripts.git /opt/pentesttools

cat <<EOF | sudo tee /usr/share/applications/oracleenum.desktop
[Desktop Entry]
Name=Oracle Enumeration Script
Exec=python3 /opt/pentesttools/enum_oracle.py
Icon=utilities-terminal
Type=Application
Categories=Utility;
Terminal=true
EOF

cat <<EOF | sudo tee /usr/share/applications/oraclevuln.desktop
[Desktop Entry]
Name=Oracle Password Script
Exec=python3 /opt/pentesttools/vuln_oracle.py
Icon=utilities-terminal
Type=Application
Categories=Utility;
Terminal=true
EOF

sudo chmod +x /usr/share/applications/oracle*.desktop

# Voeg ze toe aan de Desktop van alle bestaande users
for u in $(ls /home); do
    user_home="/home/$u"
    sudo mkdir -p "$user_home/Desktop"
    sudo cp /usr/share/applications/oracle*.desktop "$user_home/Desktop/"
    sudo chown "$u:$u" "$user_home/Desktop/"*.desktop
    sudo chmod +x "$user_home/Desktop/"*.desktop
done

# Voor toekomstige users
sudo mkdir -p /etc/skel/Desktop
sudo cp /usr/share/applications/oracle*.desktop /etc/skel/Desktop/
sudo chmod +x /etc/skel/Desktop/oracle*.desktop

echo "Setting op boa cli"
wget https://github.com/openbao/openbao/releases/download/v2.2.2/bao_2.2.2_linux_amd64.deb
sudo dpkg -i bao_2.2.2_linux_amd64.deb

echo "Setting VAULT_ADDR globally"
VAULT_ADDR_VALUE="http://172.200.72.230:8200"

for u in $(ls /home); do
    bashrc="/home/$u/.bashrc"
    if grep -q "export VAULT_ADDR=" "$bashrc" 2>/dev/null; then
        sudo sed -i "s|export VAULT_ADDR=.*|export VAULT_ADDR=$VAULT_ADDR_VALUE|" "$bashrc"
    else
        echo "export VAULT_ADDR=$VAULT_ADDR_VALUE" | sudo tee -a "$bashrc"
    fi
    sudo chown "$u:$u" "$bashrc"
done

if grep -q "export VAULT_ADDR=" /etc/skel/.bashrc; then
    sudo sed -i "s|export VAULT_ADDR=.*|export VAULT_ADDR=$VAULT_ADDR_VALUE|" /etc/skel/.bashrc
else
    echo "export VAULT_ADDR=$VAULT_ADDR_VALUE" | sudo tee -a /etc/skel/.bashrc
fi

sudo sed -i '/^VAULT_ADDR=/d' /etc/environment
echo "VAULT_ADDR=$VAULT_ADDR_VALUE" | sudo tee -a /etc/environment

export VAULT_ADDR=$VAULT_ADDR_VALUE
echo "Ingestelde VAULT_ADDR voor huidige shell: $VAULT_ADDR"
