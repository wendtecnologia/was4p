#!/bin/bash
###
# Project: WAS4P
# Author: Walker de Alencar (@walkeralencar)
###

echo "Copiando configuracoes..."
cp -f ../data/etc/network/interfaces /etc/network/interfaces
echo "Ok"

echo "Iniciando as interfaces"
ifup eth0
