#!/bin/sh
cpsBin="~/.composer/bin"
cpsProfile="/etc/bash.bashrc"

echo -n "Instalando PHP Quality Assurance Toolchain..."
echo -n "Instalando composer... "
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
echo "Ok"

echo -n "Instalando phpqatools... "
composer global require 'wend/phpqatools=*'
echo "Ok"

echo -n "Definindo PATH com o composer..."
if ! egrep -q "$cpsBin" $cpsProfile ; then
    echo "## Composer Bin" >> $cpsProfile
    echo "export PATH=\$PATH:$cpsBin" >> $cpsProfile
    echo -n " definido. "
else
    echo -n " estava definido. "
fi
echo "Ok"
