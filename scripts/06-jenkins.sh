#!/bin/sh

echo -n "Instalando jenkins... "
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install -y jenkins
echo "Ok"

echo -n "Instalando Plugins do Jenkins... "
wget http://localhost:8080/jnlpJars/jenkins-cli.jar
curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin checkstyle cloverphp crap4j dry htmlpublisher jdepend plot pmd violations xunit
java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart
echo "Ok"

