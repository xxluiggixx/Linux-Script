#!/bin/bash
path='/u01/app/tomcat/apache-tomcat/'
file='glowroot-0.13.6-dist.zip'

sed -i 's|JAVA_OPTS="-Xms5024M -Xmx5024M"|JAVA_OPTS="-Xms5024M -Xmx5024M -javaagent:/u01/app/tomcat/apache-tomcat/glowroot/glowroot.jar"|' /etc/tomcat/tomcat.conf
unzip $file 
mv  ./glowroot $path

cat <<EOF >> /u01/app/tomcat/apache-tomcat/glowroot/admin.json
{
  "web": {
    "bindAddress": "0.0.0.0"
  }
}
EOF

chown -R tomcat $(echo $path)glowroot

systemctl restart tomcat