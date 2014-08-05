#!/bin/bash
###
# WAS4P - Web Application Server for PHP by [Wend Tecnologia (@wendtecnologia)]
# Author: Walker de Alencar (@walkeralencar)
# 
###

## Functions
function pause(){
   read -p "$*"
}
function pausePressKey(){ 
   pause "Press [Enter] key to continue..."
}

## Constants
root_path=`dirname $0`

cd $root_path/scripts

./04-zendserver.sh

echo ""
echo -n "ATENTION: Access Zend Server UI, complete all steps. After that come back to script and "
pausePressKey
echo ""
./94-setpath.sh
