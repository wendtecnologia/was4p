#!/bin/sh

echo -n "Instalando PHP Quality Assurance Toolchain..."

pear channel-discover pear.phpqatools.org
auto_discover=`pear config-get auto_discover`
pear config-set auto_discover 1
pear install phpqatools/phpqatools
pear config-set auto_discover $auto_discover

echo "Ok"
