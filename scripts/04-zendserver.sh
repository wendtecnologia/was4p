#!/bin/sh

path=`dirname $0`
echo -n "Instalando Zend Server com PHP 5.4..."
chmod +x $path/../data/ZendServer/install_zs.sh

$path/../data/ZendServer/install_zs.sh 5.4 --automatic
echo "Ok"

# Set bin path
$path/94-setpath.sh
