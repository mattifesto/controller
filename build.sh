#!/usr/bin/env sh

BUILD_DIRECTORY=tmp/build



# build

rm -rf $BUILD_DIRECTORY
mkdir -p $BUILD_DIRECTORY

cp src/* $BUILD_DIRECTORY
cp version.txt $BUILD_DIRECTORY



# install

rm -rf /var/www/html
mkdir /var/www/html
chmod 1777 /var/www/html
chown www-data:www-data /var/www/html

cp $BUILD_DIRECTORY/* /var/www/html
