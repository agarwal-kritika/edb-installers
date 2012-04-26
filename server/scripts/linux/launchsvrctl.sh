#!/bin/sh
# Copyright (c) 2012, EnterpriseDB Corporation.  All rights reserved

# PostgreSQL server control launch script for Linux

for shell in xterm konsole gnome-terminal
do
    which $shell > /dev/null 2>&1
    if [ $? -eq 0 ];
    then
        if [ x"$shell" = x"konsole" ]
        then
            `which $shell` -e "PG_INSTALLDIR/scripts/serverctl.sh" $1 wait
        else
            `which $shell` -e "PG_INSTALLDIR/scripts/serverctl.sh $1 wait"
        fi
        exit 0
    fi
done

