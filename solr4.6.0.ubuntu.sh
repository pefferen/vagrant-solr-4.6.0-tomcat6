#!/bin/bash

# Assumption we are using Ubuntu precise 64 bits (12.04)

# First we update apt
sudo apt-get update
sudo apt-get upgrade

# Install tomcat
sudo apt-get install tomcat6 tomcat6-admin tomcat6-common tomcat6-user -y

# Download Solr 4.6.0 in the the directory and extract install
cd /tmp

# If Solr archive is not available locally download it
if [ ! -f "solr-4.6.0.tgz" ]; then
  # Download Solr
  wget http://apache.mirror.1000mbps.com/lucene/solr/4.6.0/solr-4.6.0.tgz
  tar xvf solr-4.6.0.tgz
fi

# check for solr base directory, if not create it
if [ ! -d "/var/solr" ]; then
  # create the Solr base directory
  mkdir /var/solr
fi

# Install Solr if it is not yet installed.
if [ ! -f "/usr/share/tomcat6/webapps/solr.war" ]; then
  # Copy the Solr webapp and the example multicore configuration files:
  sudo mkdir /usr/share/tomcat6/webapps
  sudo cp /tmp /solr-4.6.0/dist/solr-4.6.0.war /usr/share/tomcat6/webapps/solr.war
  sudo cp -R /tmp/solr/solr-4.6.0/example/multicore/* /usr/share/solr/
fi

# Add configuration to settings file.
echo "Configuring Solr"
sudo echo "<Context docBase=\"/usr/share/tomcat6/webapps/solr.war\" debug=\"0\" privileged=\"true\"
         allowLinking=\"true\" crossContext=\"true\">
    <Environment name=\"solr/home\" type=\"java.lang.String\"
                 value=\"/usr/share/solr/\" override=\"true\" />
</Context>" > /etc/tomcat6/Catalina/localhost/solr.xml


# Set filepermissions
echo "Set filepermissions"
sudo chgrp -R tomcat6 /usr/share/solr
sudo chmod -R 2755 /usr/share/solr
#sudo chmod -R 2775 /usr/share/solr/
sudo chmod -R o+x /usr/share/tomcat6/lib

## set filepermissions to Tomcat user
#sudo chown -R tomcat6 /var/solr/

# Configure log4j logging
echo "Configure log4j loggin"
sudo cp /usr/share/solr4/resources/log4j.properties /usr/share/tomcat6/lib
sudo chown tomcat6:tomcat6 /usr/share/tomcat6/lib/log4j.properties

# Setup Tomcat user.
echo "Setup Tomcat user."
sudo echo "<tomcat-users>
    <role rolename=\"admin\"/>
    <role rolename=\"manager\"/>
    <user username=\"triquanta\" password=\"aS2k4Ddf\" roles=\"admin,manager\"/>
</tomcat-users>" > /etc/tomcat6/tomcat-users.xml


echo "Ubuntu, Tomcat and Solr have been installed."
