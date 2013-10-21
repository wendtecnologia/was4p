#!/bin/sh

echo "This script will define the nginx.org repository on your system"
echo "See support matrix at http://nginx.org/en/linux_packages.html#distributions"
echo

if [ ! -f /etc/issue ]; then
	echo "/etc/issue not found, cannot identify your OS version"
	exit 2
elif grep -q "CentOS release 5" /etc/issue; then
	OS=centos
	OSRELEASE=5
	TYPE=rpm
elif grep -q "CentOS release 6" /etc/issue; then
	OS=centos
	OSRELEASE=6
	TYPE=rpm
elif grep -q "Red Hat Enterprise Linux Server release 5" /etc/issue; then
	OS=rhel
	OSRELEASE=5
	TYPE=rpm
elif grep -q "Red Hat Enterprise Linux Server release 6" /etc/issue; then
	OS=rhel
	OSRELEASE=6
	TYPE=rpm
elif grep -q "Debian GNU/Linux 6" /etc/issue; then
	OS=debian
	OSRELEASE=squeeze
	TYPE=deb
elif grep -q "Debian GNU/Linux 7" /etc/issue; then
	OS=debian
	OSRELEASE=wheezy
	TYPE=deb
elif grep -q "Ubuntu 10.04" /etc/issue; then
	OS=ubuntu
	OSRELEASE=lucid
	TYPE=deb
elif grep -q "Ubuntu 11.10" /etc/issue; then
	OS=ubuntu
	OSRELEASE=oneiric
	TYPE=deb
elif grep -q "Ubuntu 12.04" /etc/issue; then
	OS=ubuntu
	OSRELEASE=precise
	TYPE=deb
elif grep -q "Ubuntu 12.10" /etc/issue; then
	OS=ubuntu
	OSRELEASE=quantal
	TYPE=deb
elif grep -q "Ubuntu 13.04" /etc/issue; then
	OS=ubuntu
	OSRELEASE=raring
	TYPE=deb
else
	echo "Cannot identify your OS version or your OS version is not supported by nginx.org"
	exit 2
fi

MYUID=`id -u 2> /dev/null`
if [ ! -z "$MYUID" ]; then
    if [ $MYUID != 0 ]; then
        echo "You need root privileges to run this script";
        exit 2
    fi
else
    echo "Could not detect UID";
    exit 2
fi

if [ "$TYPE" = "rpm" ]; then
	wget http://nginx.org/keys/nginx_signing.key 2> /dev/null && rpm --import nginx_signing.key; rm -f nginx_signing.key
	SOURCE_REPO_FILE=`dirname $0`/nginx.repo
	TARGET_REPO_FILE=/etc/yum.repos.d/nginx.repo
elif [ "$TYPE" = "deb" ]; then
	wget http://nginx.org/keys/nginx_signing.key -O- 2> /dev/null | apt-key add -
	SOURCE_REPO_FILE=`dirname $0`/nginx.list
	TARGET_REPO_FILE=/etc/apt/sources.list.d/nginx.list
else
	echo "Package manager type not defined, cannot configure repository"
	exit 2
fi

# Set repository 
cp -f $SOURCE_REPO_FILE $TARGET_REPO_FILE && sed "s/OSRELEASE/$OSRELEASE/g" -i $TARGET_REPO_FILE &&  sed "s/OS/$OS/g" -i $TARGET_REPO_FILE
if [ $? = 0 ]; then
	echo
	echo "*** nginx.org repository configured successfully at $TARGET_REPO_FILE ***" 
fi
