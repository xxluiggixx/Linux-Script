#!/bin/bash

# INFORMATION
# Guide: https://igunawan.com/how-to-monitor-basic-metrics-from-nginx-with-prometheus-and-grafana/

#Modificar por la ip de la maquina
read -p 'Ingrese la ip del equipo' local_ip


### NGINX CONFIG MODULE#####
#Adding nginx config
cat <<EOF >> /etc/nginx/sites-available/default
##Modulo de export metric####
	server{
		listen localhost:9113;
		location /metrics {
			stub_status on;
		}
	}
EOF

service nginx restart

#Port firewall
ufw allow 9113/tcp

### PROMETHEUS EXPORTER - NGINX ####
# REPOSITORIE: https://github.com/nginxinc/nginx-prometheus-exporter/releases/tag/v0.11.0
wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.11.0/nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz -O ngix.tar.gz
tar -xf ngix.tar.gz
mv nginx-prometheus-exporter /usr/local/bin/
useradd -r nginx_exporter


#Create Systemd Service File configruation
cat <<EOF >> /etc/systemd/system/nginx_prometheus_exporter.service
[Unit]
Description=NGINX Prometheus Exporter
After=nginx.service
[Service]
Type=simple
User=nginx_exporter
Group=nginx_exporter
Type=simple
ExecStart=/usr/local/bin/nginx-prometheus-exporter \
    -web.listen-address=$($local_ip):9113 \
    -nginx.scrape-uri http://127.0.0.1:9113/metrics
SyslogIdentifier=nginx_prometheus_exporter
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart nginx_prometheus_exporter