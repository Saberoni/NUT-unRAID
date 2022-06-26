#!/bin/sh
BOOT="/boot/config/plugins/nut"
DOCROOT="/usr/local/emhttp/plugins/nut"

# Add nut user and group for udev at shutdown
if [ $( grep -ic "218" /etc/group ) -eq 0 ]; then
    groupadd -g 218 nut
fi

if [ $( grep -ic "218" /etc/passwd ) -eq 0 ]; then
    useradd -u 218 -g nut -s /bin/false nut
fi

# Update file permissions of scripts
chmod +0755 $DOCROOT/scripts/* \
        /etc/rc.d/rc.nut \
        /usr/sbin/nut-notify

# copy the default
cp -nr $DOCROOT/default.cfg $BOOT/nut.cfg

# remove nut symlink
if [ -L /etc/ups ]; then
    rm -f /etc/ups
    mkdir /etc/ups
fi

# copy conf files
cp -nr $DOCROOT/nut/* /etc/ups

if [ -d $BOOT/ups ]; then
    cp -f $BOOT/ups/* /etc/ups
fi

# update permissions
if [ -d /etc/ups ]; then
    chown -R 218:218 /etc/ups
    chmod -R -r /etc/ups
fi
