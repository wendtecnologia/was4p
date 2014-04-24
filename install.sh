#!/bin/sh
###
# WAS4P - Web Application Server for PHP by [Wend Tecnologia (@wendtecnologia)]
# Author: Walker de Alencar (@walkeralencar)
# 
###

## Constants
root_path=`dirname $0`

cd $root_path/scripts
./03-upgrade.sh
./04-zendserver.sh

