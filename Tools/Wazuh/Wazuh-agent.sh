#!/bin/bash
#===============>INFORMATION<=================
# Install Wazuh agent for both operative system .deb .rpm
# and create user seguridad for management
#Created: 6-5-24
#Author: García Salado Luis María
RPM_REPOSITORIE="https://packages.wazuh.com/4.x/yum/wazuh-agent-4.7.4-1.x86_64.rpm"
DEB_REPOSITORIE="https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.4-1_amd64.deb"
OS=$(hostnamectl | grep -i "operating" | awk '{print $3}')


read -p "Wazuh Manager IP: " WazuhManager 
read -p "New user name: " NEWUSER 
read -ps 'Password for $NEWUSER: ' PASS

if [[ $OS = "Ubuntu" || $OS = "Debian" ]]
    then
    echo 'Installing Wazuh Agent for $OS'
    wget $DEB_REPOSITORIE -O wazuh-agent.deb && chmod +x wazuh-agent.deb
    WAZUH_MANAGER='$WazuhManager' dpkg -i wazuh-agent.deb
    else
    echo 'Installing Wazuh Agent for $OS'
    wget $RPM_REPOSITORIE -O wazuh-agent.rpm && chmod +x wazuh-agent.rpm
    WAZUH_MANAGER='$WazuhManager' rpm -i wazuh-agent.rpm

fi

if [[ $? -eq 0 ]]
    then
    echo "Remove agent file"
    rm wazuh-agent.deb
    else
    echo "Error installing agent"
    exit 1
fi    

# Reload and enable services
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent.service

#Create user and add wazuh group
useradd -p $(openssl passwd -1 $PASS) $NEWUSER && usermod -aG wazuh $NEWUSER

#Add user config ssh
[[ -e /etc/ssh/sshd_config ]] &&  echo 'AllowUsers $NEWUSER' >> /etc/ssh/sshd_config