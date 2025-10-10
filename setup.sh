#!/bin/bash

set -e

echo -e "\n[+] Updating and installing SSH server..."
sudo apt update && sudo apt install -y openssh-server curl

echo -e "\n[+] Generating SSH key pair..."
mkdir -p ~/.ssh
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

echo -e "\n[+] Configuring SSH server..."
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo service ssh start

echo -e "\n========== YOUR PRIVATE SSH KEY ==========\n"
cat ~/.ssh/id_rsa
echo -e "\n========== END OF PRIVATE KEY ==========\n"

echo -e "\n[+] Starting public tunnel via serveo.net..."
echo -e "[*] Keep this Codespace terminal open to keep the tunnel alive."

# Create persistent reverse tunnel
ssh -o StrictHostKeyChecking=no -R 2222:localhost:22 serveo.net
