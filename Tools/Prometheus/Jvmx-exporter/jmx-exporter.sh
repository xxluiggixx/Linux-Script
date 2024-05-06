#!/bin/bash
#===============>INFORMATION<=================
#Repositore: https://github.com/prometheus/jmx_exporter
## Install
#First download jmx exporter agent for jave applicattion 
#Created: 07-06-23
#Author: García Salado Luis María


#### Variable Definition ####
url_java='https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.20.0/jmx_prometheus_javaagent-0.20.0.jar'
folder="jvmx_exporter"
port='12345'
path='/opt/tomcat/'
agent='prometheus_javaagent.jar'
full_path="${path}${folder}"
##########################################
mkdir $full_path

#Download agent
wget -c $url_java -O $full_path/$agent

# Create env file
cat <<EOF >> $(echo $full_path)/../bin/setenv.sh
#!/bin/bash
export JAVA_OPTS="$JAVA_OPTS -javaagent:$(echo $full_path)/$(echo $agent)=$(echo $port):$(echo $full_path)/config.yaml"
EOF

chown -R tomcat $full_path/setenv.sh

#Create config file
cat <<EOF >> $(echo $full_path)/config.yaml
# https://grafana.com/grafana/dashboards/8704-tomcat-dashboard/
---   
lowercaseOutputLabelNames: true
lowercaseOutputName: true
whitelistObjectNames: ["java.lang:type=OperatingSystem", "Catalina:*"]
blacklistObjectNames: []
rules:
  - pattern: 'Catalina<type=Server><>serverInfo: (.+)'
    name: tomcat_serverinfo
    value: 1
    labels:
      serverInfo: "$1"
    type: COUNTER
  - pattern: 'Catalina<type=GlobalRequestProcessor, name=\"(\w+-\w+)-(\d+)\"><>(\w+):'
    name: tomcat_$3_total
    labels:
      port: "$2"
      protocol: "$1"
    help: Tomcat global $3
    type: COUNTER
  - pattern: 'Catalina<j2eeType=Servlet, WebModule=//([-a-zA-Z0-9+&@#/%?=~_|!:.,;]*[-a-zA-Z0-9+&@#/%=~_|]), name=([-a-zA-Z0-9+/$%~_-|!.]*), J2EEApplication=none, J2EEServer=none><>(requestCount|processingTime|errorCount):'
    name: tomcat_servlet_$3_total
    labels:
      module: "$1"
      servlet: "$2"
    help: Tomcat servlet $3 total
    type: COUNTER
  - pattern: 'Catalina<type=ThreadPool, name="(\w+-\w+)-(\d+)"><>(currentThreadCount|currentThreadsBusy|keepAliveCount|connectionCount|acceptCount|acceptorThreadCount|pollerThreadCount|maxThreads|minSpareThreads):'
    name: tomcat_threadpool_$3
    labels:
      port: "$2"
      protocol: "$1"
    help: Tomcat threadpool $3
    type: GAUGE
  - pattern: 'Catalina<type=Manager, host=([-a-zA-Z0-9+&@#/%?=~_|!:.,;]*[-a-zA-Z0-9+&@#/%=~_|]), context=([-a-zA-Z0-9+/$%~_-|!.]*)><>(processingTime|sessionCounter|rejectedSessions|expiredSessions):'
    name: tomcat_session_$3_total
    labels:
      context: "$2"
      host: "$1"
    help: Tomcat session $3 total
    type: COUNTER   
EOF

chown -R tomcat:tomcat $(echo $full_path)/$(echo $file)

chmod 710 $(echo $full_path)/$(echo $file)

systemctl restart tomcat