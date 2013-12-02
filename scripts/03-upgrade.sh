#!/bin/bash
###
# Project: WAS4P
# Author: Walker de Alencar (@walkeralencar)
###

echo -n "Atualizando pacotes..."
apt-get update
apt-get upgrade -y
echo "Atualizando pacotes... OK"
