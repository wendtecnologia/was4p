#!/bin/sh


setpath(){
  echo -n "Definindo PATH em [$profile]..."
  if ! egrep -q "/usr/local/zend/bin" $profile ; then
    echo "## Zend Server Bin" >> $profile
    echo "export PATH=\$PATH:$zsbin:$zfbin" >> $profile
    echo -n " definido. "
  else
    echo -n " estava definido. "
  fi
  echo "OK"
}

zsbin="/usr/local/zend/bin"
zfbin="/usr/local/zend/var/libraries/Zend_Framework_1/default/bin"
profile="/etc/bash.bashrc"
setpath

echo -n "Criando link simbolico 'zf' do Zend Framework 1/bin/zf.sh..."
chmod +x $zfbin/zf.sh
ln -sf $zfbin/zf.sh /usr/bin/zf
echo "OK"
