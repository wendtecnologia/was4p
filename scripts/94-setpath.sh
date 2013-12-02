#!/bin/sh
## constants
zsbin="/usr/local/zend/bin"
zfbin="/usr/local/zend/var/libraries/Zend_Framework_1/default/bin"

## functions
setpath(){
  profile=$1
  echo -n "Definindo PATH em [$profile]..."
  if ! egrep -q "$zsbin" $profile ; then
    echo "## Zend Server Bin" >> $profile
    echo "export PATH=\$PATH:$zsbin:$zfbin" >> $profile
    echo -n " definido. "
  else
    echo -n " estava definido. "
  fi
  echo "OK"
}

##actions
setpath "/etc/bash.bashrc"

echo -n "Criando link simbolico 'zf' do Zend Framework 1/bin/zf.sh..."
chmod +x $zfbin/zf.sh
ln -sf $zfbin/zf.sh /usr/bin/zf
echo "OK"
