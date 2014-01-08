#!/bin/bash

# Assumption we are using Ubuntu precise 64 bits (12.04)

# First we update apt
sudo apt-get update

# Install tomcat
sudo apt-get install tomcat6 -y



# Download Solr 3.6.1 in the the directory and extract install
mkdir -p /tmp/solr/
cd /tmp/solr/

wget http://apache.mirror.1000mbps.com/lucene/solr/4.6.0/solr-4.6.0-src.tgz
tar xvf solr-4.6.0.tgz

# check for solr base directory, if not create it
if [ ! -d "/var/solr" ]; then
  # create the Solr base directory
  mkdir /var/solr
fi

# Copy the Solr webapp and the example multicore configuration files:
# sudo cp solr-4.6.0/dist/apache-solr-3.6.1.war /var/solr/solr.war
# sudo cp -R apache-solr-3.6.1/example/multicore/* /var/solr/

# set filepermissions to Tomcat user
sudo chown -R tomcat6 /var/solr/
