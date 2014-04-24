#!/bin/sh

usage()
{
cat <<EOF

Usage: $0 <php_version> [nginx] [java] [--automatic]
Where php_version is either 5.3 or 5.4.

EOF
return 0
}

# on OEL, /etc/issue states "Enterprise Linux Enterprise Linux Server"
SUPPORTED_OS='CentOS|Red Hat Enterprise Linux Server|Enterprise Linux Enterprise Linux Server|Mint|SUSE|Debian GNU/Linux|Ubuntu|Oracle Linux Server'


if `which lsb_release > /dev/null 2>&1`; then
	CURRENT_OS=`lsb_release -d -s`
elif [ -f /etc/issue ]; then
	CURRENT_OS=`head -2 /etc/issue`
else
	echo "Can't identify your system using lsb_release or /etc/issue in order to"
	echo "configure Zend's DEB/RPM repositories."
	exit 1
fi
	
if ! echo $CURRENT_OS | egrep -q "$SUPPORTED_OS"; then
cat <<EOF

Unable to install: Your distribution is not suitable for installation using
Zend's DEB/RPM repositories (based on either lsb_release or /etc/issue).

EOF
    exit 1
fi

# -v or --version
if [ "$1" = "-v" -o "$1" = "--version" ]; then
	echo "`basename $0` version 6.1.0 (build: \$Revision: 77536 $)"
	usage
	exit 0
fi

# -h or --help
if [ "$1" = "-h" -o "$1" = "--help" ]; then
	usage
	exit 0
fi

# No parameters
if [ $# -lt 1 ]; then
	usage
	exit 2
fi

# Verify parameter
if [ "$1" != "5.3" -a "$1" != "5.4" ]; then
	usage
	exit 2
else
	PHP=$1
	if [ "$2" = "nginx" ]; then
		shift
		NGINX="nginx"
		WHAT_TO_INSTALL="zend-server-nginx-php-$PHP"
	else
		WHAT_TO_INSTALL="zend-server-php-$PHP"
	fi

	if [ "$2" = "java" ]; then
		shift
		WHAT_TO_INSTALL="$WHAT_TO_INSTALL php-$PHP-java-bridge-zend-server"
	fi
fi


MYUID=`id -u 2> /dev/null`
if [ ! -z "$MYUID" ]; then
    if [ $MYUID != 0 ]; then
        echo "You need root privileges to run this script.";
        exit 2
    fi
else
    echo "Could not detect UID";
    exit 2
fi

if echo $CURRENT_OS | egrep -q "Ubuntu 13.10"; then
cat <<EOF

Ubuntu 13.10 comes with Apache 2.4, which is currently not supported by Zend 
Server. To install Zend Server on Ubuntu 13.10, you can either use our nginx 
solution, or make sure Apache 2.2 is installed.
EOF
fi

cat <<EOF

Running this script will perform the following:
* Configure your package manager to use Zend Server repository 
* Install Zend Server (PHP $PHP) on your system using your package manager

EOF

if [ "$2" = "--automatic" ]; then
	if which zypper > /dev/null 2>&1; then
		AUTOMATIC="-n --gpg-auto-import-keys"
	else
		AUTOMATIC="-y"
	fi
else
	AUTOMATIC=""
fi

if [ -z "$AUTOMATIC" ]; then
cat <<EOF
Hit ENTER to install Zend Server (PHP $PHP), or Ctrl+C to abort now.
EOF
# give read a parameter, as it required in dash
read answer
fi

# Upgrade check
UPGRADE=0
echo -n "Tool for checking existing installation: "
if which dpkg 2> /dev/null; then
	INSTALLED_PACKAGES=`dpkg -l '*zend*' | grep ^ii | awk '{print $2}'`
	if `dpkg -l "zend-server*" | grep ^ii | grep -q -E "php-5|cluster-manager"`; then
		UPGRADE=1;
	else
		INSTALLED_PHP_PACKAGES=`dpkg -l libapache2-mod-php5 | grep ^ii | awk '{print $2}'`;
	fi
elif which rpm 2> /dev/null; then
	INSTALLED_PACKAGES=`rpm -qa --qf="%{NAME}\n" '*zend*'`
	if `rpm -qa | grep "^zend-server" | grep -q -E "php-5|cluster-manager"`; then
		UPGRADE=1;
	fi
else
	echo
	echo "Your system doesn't support either dpkg or rpm"
	exit 2
fi

# Check if upgrade is allowed
if [ "$UPGRADE" = "1" ]; then
	if [ -f /etc/zce.rc ]; then
		. /etc/zce.rc
	fi

	echo "Found existing installation of Zend Server ($PRODUCT_VERSION)"

	INSTALLED_PHP=`/usr/local/zend/bin/php -v | head -1 | cut -f2 -d" "`
	INSTALLED_PHP_MAJOR=`echo $INSTALLED_PHP | cut -f1,2 -d"."`

	if [ "$INSTALLED_PHP" = "5.3.15" -o "$INSTALLED_PHP" = "5.4.5" ]; then
		echo "Upgrade from ZendServer 6.0 Beta isn't supported."
		exit 2
	elif [ "$INSTALLED_PHP" = "5.4.0-ZS5.6.0" ]; then
		echo "Upgrade from ZendServer 5.6.0 with PHP 5.4 technology preview isn't supported."
		exit 2
	elif echo "$INSTALLED_PACKAGES" | grep -q cluster-manager; then
		echo "Upgrade from ZendServer cluster manager isn't supported."
		exit 2
	elif [ "$PRODUCT_VERSION" = "5.0.4" -o "$PRODUCT_VERSION" = "5.1.0" -o "$PRODUCT_VERSION" = "5.5.0" ]; then
		echo "Upgrade from version $PRODUCT_VERSION isn't supported."
		exit 2
	elif [ "$INSTALLED_PHP_MAJOR" = "5.4" -a "$PHP" = "5.3" ]; then
		echo "Downgrade from PHP $INSTALLED_PHP_MAJOR to $PHP isn't supported."
		exit 2
	elif echo "$INSTALLED_PACKAGES" | grep -q nginx && [ -z "$NGINX" ]; then
		echo "Zend Server with nginx cannot be upgraded to a different installation type of Zend Server."
		echo "Please uninstall Zend Server and perform a clean installation."
		exit 2
	elif ! (echo "$INSTALLED_PACKAGES" | grep -q nginx) && [ -n "$NGINX" ]; then
		echo "The Zend Server installation type you are currently using cannot be upgraded to Zend Server with nginx."
		echo "Please uninstall Zend Server and perform a clean installation."
		exit 2
	fi
else
	if [ -n "$INSTALLED_PHP_PACKAGES" ] && [ -z "$NGINX" ]; then
		echo "Found PHP package $INSTALLED_PHP_PACKAGES from your distribution, please remove it before installing Zend Server"
		exit 2
	fi
fi

# Set nginx.org repository 
if [ "$NGINX" = "nginx" ]; then
	`dirname $0`/nginx/install_nginx.sh
	if [ $? != 0 ]; then
		exit 2
	fi
fi

# Set repository 
echo -n "Doing repository configuration for: "
if which apt-get 2> /dev/null; then
	if echo $CURRENT_OS | grep -q -E "Debian GNU/Linux 5|Debian GNU/Linux 6|Ubuntu 10"; then
		REPO_FILE=`dirname $0`/zend.deb.repo
	else
		# This is the default for Debian >> 6 and Ubuntu >> 10.04
		REPO_FILE=`dirname $0`/zend.deb_ssl1.0.repo
	fi

	TARGET_REPO_FILE=/etc/apt/sources.list.d/zend.list
	SYNC_COMM="apt-get update"
	wget http://repos.zend.com/zend.key -O- 2> /dev/null | apt-key add -
elif which yum 2> /dev/null; then
	if [ -d /etc/yum/repos.d ]; then
		# OpenSUSE
		REPO_FILE=`dirname $0`/zend.rpm.suse.repo
		TARGET_REPO_FILE=/etc/yum/repos.d/zend.repo

		# Change arch in the repo file 
		if [ "`uname -m`" == "x86_64" ]; then
			ARCH=x86_64;
		elif [ "`uname -m`" == "i686" ]; then
			ARCH=i586;
		fi
		SYNC_COMM="sed -i \"s/\\\$basearch/$ARCH/g\" ${TARGET_REPO_FILE};"
	else
		# Fedora / RHEL / Centos
		REPO_FILE=`dirname $0`/zend.rpm.repo
		TARGET_REPO_FILE=/etc/yum.repos.d/zend.repo
	fi
	if [ "$UPGRADE" = "1" ]; then
		SYNC_COMM="$SYNC_COMM yum clean all"
	fi
elif which zypper 2> /dev/null; then
	REPO_FILE=`dirname $0`/zend.rpm.suse.repo
	TARGET_REPO_FILE=/etc/zypp/repos.d/zend.repo
	if [ "$UPGRADE" = "1" ]; then
		SYNC_COMM="zypper clean -a"
	fi

	mkdir -p /etc/zypp/repos.d

	# Change arch in the repo file 
	if [ "`uname -m`" == "x86_64" ]; then
		ARCH=x86_64;
	elif [ "`uname -m`" == "i686" ]; then
		ARCH=i586;
	fi
	SYNC_COMM="sed -i \"s/\\\$basearch/$ARCH/g\" ${TARGET_REPO_FILE}; $SYNC_COMM"
else
	echo
	echo "Can't determine which repository should be setup (apt-get, yum or zypper)"
	exit 2
fi

cp $REPO_FILE $TARGET_REPO_FILE
if [ $? != 0 ]; then
	echo
	echo "***************************************************************************************"
	echo "* Zend Server Installation was not completed. Can't setup package manager repository. *" 
	echo "***************************************************************************************"
	exit 2
fi

if [ -n "$SYNC_COMM" ]; then
	eval $SYNC_COMM
fi

RC=0


# Clean Installation
if [ "$UPGRADE" = "0" ]; then
	echo -n "Package manager for installation: "
	if which aptitude 2> /dev/null; then
		aptitude $AUTOMATIC install $WHAT_TO_INSTALL
		RC=$?
		dpkg-query -W -f='${Package} ${Version}\n' $WHAT_TO_INSTALL 2> /dev/null
		VERIFY_RC=$?
	elif which apt-get 2> /dev/null; then
		apt-get $AUTOMATIC install $WHAT_TO_INSTALL
		RC=$?
		dpkg-query -W -f='${Package} ${Version}\n' $WHAT_TO_INSTALL 2> /dev/null
		VERIFY_RC=$?
	elif which yum 2> /dev/null; then
		yum $AUTOMATIC install $WHAT_TO_INSTALL
		RC=$?
		rpm -q --qf "%{name} %{version}\n" $WHAT_TO_INSTALL 2> /dev/null
		VERIFY_RC=$?
	elif which zypper 2> /dev/null; then
		zypper $AUTOMATIC install $WHAT_TO_INSTALL
		RC=$?
		rpm -q --qf "%{name} %{version}\n" $WHAT_TO_INSTALL 2> /dev/null
		VERIFY_RC=$?
	else
		echo
		echo "Can't determine which package manager (aptitude, apt-get, yum or zypper) should be used for installation of $WHAT_TO_INSTALL"
		exit 2
	fi
fi

# Upgrade
if [ "$UPGRADE" = "1" ]; then
	if [ -f /etc/zce.rc ]; then
		. /etc/zce.rc
	fi

	# Backup etc
	BACKUP_SUFFIX=$PRODUCT_VERSION
	
	if [ ! -d $ZCE_PREFIX/etc-$BACKUP_SUFFIX ]; then
		mkdir $ZCE_PREFIX/etc-$BACKUP_SUFFIX
	fi

	cp -rp $ZCE_PREFIX/etc/* $ZCE_PREFIX/etc-$BACKUP_SUFFIX/

	if [ ! -d $ZCE_PREFIX/lighttpd-etc-$BACKUP_SUFFIX ]; then
		mkdir $ZCE_PREFIX/lighttpd-etc-$BACKUP_SUFFIX
	fi

	cp -rp $ZCE_PREFIX/gui/lighttpd/etc/* $ZCE_PREFIX/lighttpd-etc-$BACKUP_SUFFIX/

	# Workaround an upgrade bug in our 6.1.0 Debian packages (ZSRV-11344)
	if [ "$BACKUP_SUFFIX" = "6.1.0" ]; then
		if which dpkg 2> /dev/null; then
			mkdir -p $ZCE_PREFIX/etc-$BACKUP_SUFFIX-workaround
			cp -rp $ZCE_PREFIX/etc/* $ZCE_PREFIX/etc-$BACKUP_SUFFIX-workaround
		fi
	fi

	echo -n "Package manager for upgrade: "
	if [ "$INSTALLED_PHP_MAJOR" = "$PHP" ]; then
		# Same PHP upgrade
		if which aptitude 2> /dev/null; then
			aptitude $AUTOMATIC install '~izend'
			RC=$?
			dpkg-query -W -f='${Package} ${Version}\n' $WHAT_TO_INSTALL 2> /dev/null
			VERIFY_RC=$?
		elif which apt-get 2> /dev/null; then
			apt-get $AUTOMATIC install $WHAT_TO_INSTALL
			RC=$?
			dpkg-query -W -f='${Package} ${Version}\n' $WHAT_TO_INSTALL 2> /dev/null
			VERIFY_RC=$?
			apt-get $AUTOMATIC install `dpkg -l '*zend*' | grep ^ii | awk '{print $2}'`
		elif which yum 2> /dev/null; then
			yum $AUTOMATIC upgrade '*zend*'
			RC=$?
			rpm -q --qf "%{name} %{version}\n" $WHAT_TO_INSTALL 2> /dev/null
			VERIFY_RC=$?
		elif which zypper 2> /dev/null; then
			zypper $AUTOMATIC update '*zend*'
			RC=$?
			rpm -q --qf "%{name} %{version}\n" $WHAT_TO_INSTALL 2> /dev/null
			VERIFY_RC=$?
		else
			echo
			echo "Can't determine which package manager (aptitude, apt-get, yum or zypper) should be used for upgrade to $WHAT_TO_INSTALL"
			exit 2
		fi
	else
		# PHP upgrade

		EXTRA_PACKAGES="zend-server-framework-dojo zend-server-framework-extras source-zend-server pdo-informix-zend-server pdo-ibm-zend-server ibmdb2-zend-server java-bridge-zend-server \-javamw-zend-server"
		WHAT_TO_INSTALL_EXTRA=""

		# Find which extra packages we have and should be installed
		for package in $EXTRA_PACKAGES; do 
			EXTRA_PACKAGE=`echo "$INSTALLED_PACKAGES" | grep $package | sed "s/$INSTALLED_PHP_MAJOR/$PHP/g"`
			if [ -n "$EXTRA_PACKAGE" ]; then
				WHAT_TO_INSTALL_EXTRA="$WHAT_TO_INSTALL_EXTRA $EXTRA_PACKAGE"
			fi
		done

		if which apt-get 2> /dev/null; then
			apt-get $AUTOMATIC install $WHAT_TO_INSTALL $WHAT_TO_INSTALL_EXTRA
			RC=$?
			if [ $RC -eq 0 ]; then
				apt-get $AUTOMATIC install `dpkg -l '*zend*' | grep ^ii | awk '{print $2}'`
			fi
			dpkg-query -W -f='${Package} ${Version}\n' $WHAT_TO_INSTALL 2> /dev/null
			VERIFY_RC=$?
		elif which yum 2> /dev/null; then
			yum $AUTOMATIC remove "zend-server*-php-5.*" && yum $AUTOMATIC remove "deployment-daemon-zend-server" && yum $AUTOMATIC remove "*zend*"
			yum $AUTOMATIC install $WHAT_TO_INSTALL $WHAT_TO_INSTALL_EXTRA
			RC=$?
			rpm -q --qf "%{name} %{version}\n" $WHAT_TO_INSTALL 2> /dev/null
			VERIFY_RC=$?
		elif which zypper 2> /dev/null; then
			zypper $AUTOMATIC remove "zend-server*-php-5.*" && zypper $AUTOMATIC remove "deployment-daemon-zend-server" && zypper $AUTOMATIC remove "*zend*"
			zypper $AUTOMATIC install $WHAT_TO_INSTALL $WHAT_TO_INSTALL_EXTRA
			RC=$?
			rpm -q --qf "%{name} %{version}\n" $WHAT_TO_INSTALL 2> /dev/null
			VERIFY_RC=$?
		else
			echo
			echo "Can't determine which package manager (aptitude, apt-get, yum or zypper) should be used for upgrade to $WHAT_TO_INSTALL"
			exit 2
		fi
	fi
fi

if [ $RC -eq 0 -a $VERIFY_RC -eq 0 ]; then
	echo
	echo "***********************************************************"
	echo "* Zend Server was successfully installed. 		*"
	echo "* 							*"
	echo "* To access the Zend Server UI open your browser at:	*"
	echo "* https://<hostname>:10082/ZendServer (secure) 		*" 
	echo "* or 							*" 
	echo "* http://<hostname>:10081/ZendServer			*" 
	echo "***********************************************************"
else
	echo
	echo "************************************************************************************************"
	echo "* Zend Server Installation was not completed. See output above for detailed error information. *" 
	echo "************************************************************************************************"
fi
echo

exit $RC
