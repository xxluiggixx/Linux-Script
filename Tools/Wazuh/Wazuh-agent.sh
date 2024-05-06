#!/bin/bash

#apt 
OS=$(hostnamectl | grep -i "operating" | awk '{print $3}')
if [[ $OS = "Ubuntu" || $OS = "Debian" ]]
    then
    echo $OS
    wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.4-1_amd64.deb -O wazuh-agent.deb && chmod +x wazuh-agent.deb
    # WAZUH_MANAGER="10.19.241.10" dpkg -i wazuh-agent.deb
    else
    echo $OS
    wget https://packages.wazuh.com/4.x/yum/wazuh-agent-4.7.4-1.x86_64.rpm -O wazuh-agent.rpm && chmod +x wazuh-agent.deb
    #WAZUH_MANAGER="10.19.241.10" rpm -i wazuh-agent.rpm

fi
#systemctl daemon-reload
#systemctl enable wazuh-agent
#systemctl start wazuh-agent
#systemctl start wazuh-agent.service
#useradd seguridad && usermod -aG wazuh seguridad