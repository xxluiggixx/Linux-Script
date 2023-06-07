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
full_path="${path}${folder}"
file='jmx_prometheus_javaagent-0.18.0.jar'
param="-server -Xms4524M -Xmx5024M -XX:MaxPermSize=192M  -XX:PermSize=96M -Xss228k -XX:+UseG1GC -XX:-UseGCOverheadLimit  -XX:MaxGCPauseMillis=250 -XX:GCTimeRatio=9 -XX:+PerfDisableSharedMem  -XX:+ParallelRefProcEnabled -XX:G1HeapRegionSize=8m -XX:InitiatingHeapOccupancyPercent=75  -XX:+UseLargePages   -XX:+AggressiveOpts -Dsolr.autoSoftCommit.maxTime=1000  -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/tomcat/heapdumps -javaagent:/u01/app/tomcat/apache-tomcat/glowroot/glowroot.jar -javaagent:$(echo $full_path)/$(echo $file)=$(echo $port):$(echo $full_path)/config.yaml"
oldParam="-server -Xms4524M -Xmx5024M -XX:MaxPermSize=192M  -XX:PermSize=96M -Xss228k -XX:+UseG1GC -XX:-UseGCOverheadLimit  -XX:MaxGCPauseMillis=250 -XX:GCTimeRatio=9 -XX:+PerfDisableSharedMem  -XX:+ParallelRefProcEnabled -XX:G1HeapRegionSize=8m -XX:InitiatingHeapOccupancyPercent=75  -XX:+UseLargePages   -XX:+AggressiveOpts -Dsolr.autoSoftCommit.maxTime=1000  -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/tomcat/heapdumps -javaagent:/u01/app/tomcat/apache-tomcat/glowroot/glowroot.jar"
##################################

mkdir $full_path
mv $file $full_path
sed -i 's|JAVA_OPTS="'"$(echo $oldParam)"'"|JAVA_OPTS="'"$(echo $param)"'"|' /etc/tomcat/tomcat.conf

cat <<EOF >> $(echo $full_path)/config.yaml
rules:
- pattern: ".*"
EOF
chown -R tomcat $(echo $full_path)/$(echo $file)
systemctl restart tomcat