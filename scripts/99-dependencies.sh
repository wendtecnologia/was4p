#!/bin/bash
###
# Project: WAS4P
# Author: Walker de Alencar (@walkeralencar)
###

echo "Instalando Git..."
apt-get install git-core git-svn subversion
echo "Ok"

echo "Iniciando as interfaces"
ifup eth0
