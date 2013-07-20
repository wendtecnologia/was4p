#!/bin/sh

echo -e -n "Instalando PHP Quality Assurance Toolchain..."

/usr/local/zend/bin/pear channel-discover pear.phpqatools.org
auto_discover=`/usr/local/zend/bin/pear config-get auto_discover`
/usr/local/zend/bin/pear config-set auto_discover 1
/usr/local/zend/bin/pear install phpqatools/phpqatools
/usr/local/zend/bin/pear config-set auto_discover $auto_discover

ln -s /usr/local/zend/bin/phpunit /usr/bin/phpunit
ln -s /usr/local/zend/bin/pdepend /usr/bin/pdepend
ln -s /usr/local/zend/bin/phpmd /usr/bin/phpmd
ln -s /usr/local/zend/bin/phpcpd /usr/bin/phpcpd
ln -s /usr/local/zend/bin/phploc /usr/bin/phploc
ln -s /usr/local/zend/bin/phpcb /usr/bin/phpcb
ln -s /usr/local/zend/bin/phpcs /usr/bin/phpcs

echo "Ok"
