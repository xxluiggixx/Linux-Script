#!/bin/bash

# INFORMATION
# The node_exporter listens on HTTP port 9100 by default
# GUIDE: https://devconnected.com/how-to-setup-grafana-and-prometheus-on-linux/#V_-_Installing_the_Node_Exporter_to_monitor_Linux_metrics

node_exporter_version="node_exporter-1.5.0.linux-amd64"

### PROMETHEUS NODE EXPORTER ####
# REPOSITORIE: https://prometheus.io/download/
#wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/$node_exporter_version.tar.gz 
tar -xf $node_exporter_version.tar.gz 
mv $node_exporter_version/node_exporter /usr/local/bin/
useradd -rs /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter

#Create Systemd Service File configruation
cat <<EOF >> /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter 

Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter