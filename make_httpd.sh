#!/bin/sh

###############################################################################
##                                                                           ##
## Build apache httpd for OSX                                                ##
##                                                                           ##
## This script is in the public domain.                                      ##
##                                                                           ##
## Creator     : Bruno LEGAY                                                 ##
##                                                                           ##
###############################################################################

PCRE_VERS="8.44"
APR_VERS="1.7.0"
APR_UTIL_VERS="1.6.1"
HTTPD_VERS="2.4.46"

# download pcre
curl -O https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERS}.tar.gz
tar xzf pcre-${PCRE_VERS}.tar.gz
cd pcre-${PCRE_VERS}

# build pcre
./configure --prefix=/usr/local    #/pcre-${PCRE_VERS}
make clean
make
sudo make install

cd ..

# download apache apr
curl -O https://downloads.apache.org//apr/apr-${APR_VERS}.tar.gz
tar xzf apr-${APR_VERS}.tar.gz
cd apr-${APR_VERS}

# build apache apr
./configure --prefix=/usr/local
make clean
make
sudo make install

cd ..


# download apache apr-util
curl -O https://downloads.apache.org//apr/apr-util-${APR_UTIL_VERS}.tar.gz
tar xzf apr-util-${APR_UTIL_VERS}.tar.gz
cd apr-util-${APR_UTIL_VERS}

# build apache apr-util
./configure --prefix=/usr/local --with-apr=/usr/local
make clean
make
sudo make install

cd ..

# download apache httpd
curl -O https://mirror.ibcp.fr/pub/apache//httpd/httpd-${HTTPD_VERS}.tar.gz
tar xzf httpd-${HTTPD_VERS}.tar.gz

# apply a patch to get "diskfree" infos in mod_dav
# http://www.carrel.org/files/dav-diskfree.patch
# https://www.tnpi.net/computing/mac/tips/idisk/dav-diskfree.patch
patch httpd-${HTTPD_VERS}/modules/dav/fs/repos.c < mod_dav_diskfree_quota.patch

# build apache httpd
cd httpd-${HTTPD_VERS}

./configure \
--prefix=/usr/local \
--with-pcre=/usr/local/bin/pcre-config \
--with-apr=/usr/local \
--enable-dav=shared \
--enable-dav-fs=shared \
--enable-dav-lock=shared \
--enable-slotmem-shm \
--enable-dav \
--enable-dav-fs \
--enable-dav-lock \
--enable-hfs_apple=shared \
--with-mpm=prefork
make clean
make
sudo make install

cd ..

/usr/local/bin/apachectl -V
/usr/local/bin/apachectl -D DUMP_MODULES

