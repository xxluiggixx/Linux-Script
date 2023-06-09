#!/bin/bash
#===============>INFORMATION<=================
#Repositore: https://github.com/prometheus/jmx_exporter
## Install
#First download jmx exporter agent for jave applicattion 
#Created: 07-06-23
#Author: García Salado Luis María


#### Variable Definition ####
folder="jvmx_exporter"
port='12345'
path='/u01/app/tomcat/apache-tomcat/'
file='jmx_prometheus_javaagent-0.18.0.jar'
full_path="${path}${folder}"
param="-server -Xms9048M -Xmx12024M -XX:MaxPermSize=192M  -XX:PermSize=96M -Xss228k -XX:+UseG1GC -XX:-UseGCOverheadLimit  -XX:MaxGCPauseMillis=250 -XX:GCTimeRatio=9 -XX:+PerfDisableSharedMem  -XX:+ParallelRefProcEnabled -XX:G1HeapRegionSize=8m -XX:InitiatingHeapOccupancyPercent=75  -XX:+UseLargePages   -XX:+AggressiveOpts -Dsolr.autoSoftCommit.maxTime=1000  -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/tomcat/heapdumps -javaagent:/u01/app/tomcat/apache-tomcat/glowroot/glowroot.jar -javaagent:$(echo $full_path)/$(echo $file)=$(echo $port):$(echo $full_path)/config.yaml"
oldParam=$(cat /etc/tomcat/tomcat.conf | grep 'JAVA_OPTS=' | grep -v '#')
##########################################
mkdir $full_path
mv $file $full_path
sed -i 's|'"${oldParam}"'"|JAVA_OPTS="'"${param}"'"|' /etc/tomcat/tomcat.conf

cat <<EOF >> $(echo $full_path)/config.yaml
rules:
- pattern: ".*"
EOF
chown -R tomcat $(echo $full_path)/$(echo $file)
chmod 755 $(echo $full_path)/$(echo $file)
systemctl restart tomcat