#!/bin/bash

########################################################
# puppet_client_solaris.sh 
########################################################	
# Description: Bootstrap system as puppet client
# Syntax: sh puppet_client_solaris.sh
# Contact: email@shafiq.in
########################################################
# Notes:
# 1) Run this script as root user
# 2) Incase script fails with dependency issues try manually
#   installing first mentioned package and execute this script again. 
########################################################

# Make sure snowballing doesn't happen
set -e

# Basic debugging
set -x

# Initialize variables
puppet_master_ip=254.254.254.254 # Make sure puppet master ip is accessible
host_file=/etc/hosts

# Update hosts file
if grep "puppet" $host_file >/dev/null 2>&1
then
echo "Puppet entry already exists in /etc/hosts"
else
echo $puppet_master_ip puppet >>$host_file
fi

# add catalog so that puppetclient can be installed using pkg-get
yes | pkgadd -n -a nocheck -d http://mirror.opencsw.org/opencsw/pkg_get.pkg all

# install puppet client
/opt/csw/bin/pkg-get -f -i puppet

# p.s. the puppet client is enabled and running by default

# restart service ... just in case
svcadm restart network/cswpuppetd:default

