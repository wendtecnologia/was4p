#!/bin/bash
###
# Project: WAS4P
# Author: Walker de Alencar (@walkeralencar)
###

echo -n "Copiando configuracoes..."
cp -f ../data/etc/network/interfaces /etc/network/interfaces
echo "Ok"
echo -n "Iniciando as interfaces..."
ifup eth0
echo "Ok"

