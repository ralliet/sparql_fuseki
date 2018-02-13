#!/bin/bash

cd home
wget https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-3.6.0.tar.gz
cd /opt
tar xzf /home/apache-jena-fuseki-3.6.0.tar.gz
rm /home/apache-jena-fuseki-3.6.0.tar.gz
ln -s apache-jena-fuseki-3.6.0 fuseki
cd /opt/fuseki
adduser --system --home /opt/fuseki --no-create-home fuseki
cd /var/lib
mkdir -p fuseki/{backups,databases,system,system_files}
chown -R fuseki fuseki
cd /var/log
mkdir fuseki
chown fuseki fuseki
cd /etc
mkdir fuseki
chown fuseki fuseki
cd /etc/fuseki
ln -s /var/lib/fuseki/* .
ln -s /var/log/fuseki logs
cd ../default
touch fuseki
echo 'export FUSEKI_HOME=/opt/fuseki' >> fuseki
echo 'export FUSEKI_BASE=/etc/fuseki' >> fuseki
echo 'FUSEKI_USER=fuseki' >> fuseki
echo 'JAVA_OPTIONS="-Xmx2048M"' >> fuseki
cd /etc/init.d
ln -s /opt/fuseki/fuseki .
update-rc.d fuseki defaults
service fuseki start
sleep 5
curl --data "dbName=skosmos&dbType=tdb" http://127.0.0.1:3030/$/datasets/
service fuseki stop
> /etc/fuseki/configuration/skosmos.ttl
wget https://raw.githubusercontent.com/lab9k/Skos/develop/Needed_files/skosmos.ttl
cat skosmos.ttl >> /etc/fuseki/configuration/skosmos.ttl
rm skosmos.ttl
/usr/sbin/service fuseki start
sleep 5

if [ $# -eq 1 ]
  then
    cp /home/shiro.ini /etc/fuseki/
    service fuseki restart
fi
