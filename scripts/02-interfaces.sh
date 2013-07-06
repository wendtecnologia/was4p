#!/bin/bash
###
# Project: WAS4P
# Author: Walker de Alencar (@walkeralencar)
###

echo -e -n "Copiando configurações..."
cp -f ../data/etc/network/interfaces /etc/network/interfaces
echo "Ok"
echo -e -n "Iniciando as interfaces..."
ifup eth0
echo "Ok"