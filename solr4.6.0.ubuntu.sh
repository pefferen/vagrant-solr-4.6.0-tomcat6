#!/bin/bash

# Assumption we are using Ubuntu precise 64 bits (12.04)

# First we update apt
sudo apt-get update

# Install tomcat
sudo apt-get install tomcat6 -y



# Download Solr 3.6.1 in the the directory and extract install
mkdir -p /tmp/solr/
cd /tmp/solr/

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
if [ ! -f "/var/solr/solr.war" ]; then
  # Copy the Solr webapp and the example multicore configuration files:
  sudo cp /tmp/solr/solr-4.6.0/dist/solr-4.6.0.war /var/solr/solr.war
  sudo cp -R /tmp/solr/solr-4.6.0/example/multicore/* /var/solr/
fi

# set filepermissions to Tomcat user
sudo chown -R tomcat6 /var/solr/

echo "Ubuntu, Tomcat and Solr have been installed."
