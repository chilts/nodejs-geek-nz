#!/bin/bash
## ----------------------------------------------------------------------------

set -e

## ----------------------------------------------------------------------------
# Set these to your preferred values.

THIS_USER=`id -un`
THIS_GROUP=`id -gn`
THIS_PWD=`pwd`
THIS_NODE=`which node`

## ----------------------------------------------------------------------------

# install any required packages
echo "Installing new npm packages ..."
npm install --production
echo

# set up Proximity
echo "Setting up Proximity ..."
sudo cp etc/proximity.d/nodejs-geek-nz /etc/proximity.d/
echo

# set up the server
echo "Setting up various directories ..."
sudo mkdir -p /var/log/nodejs-geek-nz/
sudo chown $THIS_USER:$THIS_GROUP /var/log/nodejs-geek-nz/
echo

# add the upstart scripts
echo "Copying upstart script ..."
m4 \
    -D __USER__=$THIS_USER \
    -D __NODE__=$THIS_NODE \
    -D  __PWD__=$THIS_PWD   \
    -D __NODE__=$THIS_NODE \
    etc/init/nodejs-geek-nz.conf.m4 | sudo tee /etc/init/nodejs-geek-nz.conf
echo

# restart the service
echo "Restarting services ..."
sudo service nodejs-geek-nz restart
echo

## --------------------------------------------------------------------------------------------------------------------
