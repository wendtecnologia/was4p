#!/bin/sh

## constants
path=`dirname $0`

#actions
echo -n "Instalando Zend Server com PHP 5.5..."
chmod +x $path/../data/ZendServer/install_zs.sh
$path/../data/ZendServer/install_zs.sh 5.5 --automatic
echo "Ok"
