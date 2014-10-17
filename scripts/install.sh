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

# set up Nginx
echo "Setting up Nginx ..."
FILE=/tmp/nz-geek-nodejs
cat /dev/null > $FILE
nginx-generator \
    --name nz-geek-nodejs \
    --domain nodejs.geek.nz \
    --type proxy \
    --var host=localhost \
    --var port=8011 \
    - >> $FILE
nginx-generator \
    --name nz-geek-nodejs-www \
    --domain www.nodejs.geek.nz \
    --type redirect \
    --var to=nodejs.geek.nz \
    - >> $FILE
nginx-generator \
    --name nz-geek-nodejs-ww \
    --domain ww.nodejs.geek.nz \
    --type redirect \
    --var to=nodejs.geek.nz \
    - >> $FILE
nginx-generator \
    --name nz-geek-nodejs-w \
    --domain w.nodejs.geek.nz \
    --type redirect \
    --var to=nodejs.geek.nz \
    - >> $FILE
sudo cp $FILE /etc/nginx/sites-enabled/
echo

# set up the server
echo "Setting up various directories ..."
sudo mkdir -p /var/log/nz-geek-nodejs/
sudo chown $THIS_USER:$THIS_GROUP /var/log/nz-geek-nodejs/
echo

# add the upstart scripts
echo "Copying supervisor script ..."
m4 \
    -D __USER__=$THIS_USER \
    -D  __PWD__=$THIS_PWD  \
    -D __NODE__=$THIS_NODE \
    etc/supervisor/conf.d/nz-geek-nodejs.conf.m4 | sudo tee /etc/supervisor/conf.d/nz-geek-nodejs.conf
echo

# restart the service
echo "Restarting services ..."
sudo supervisorctl reload
sudo service nginx restart
echo

## --------------------------------------------------------------------------------------------------------------------
