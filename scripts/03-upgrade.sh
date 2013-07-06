#!/bin/bash
###
# Project: WAS4P
# Author: Walker de Alencar (@walkeralencar)
###

echo -e -n "Atualizando pacotes..."
apt-get update
apt-get upgrade -y
echo "Atualização completa!"