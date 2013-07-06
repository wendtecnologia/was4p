#!/bin/bash
###
# Project: WAS4P
# Author: Walker de Alencar (@walkeralencar)
###

echo "Copiando configurações"
cp -f ../data/etc/network/interfaces /etc/network/interfaces

# Iniciando as interfaces
ifup eth0
ifup eth1