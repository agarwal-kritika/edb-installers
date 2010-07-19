#!/bin/bash

# PostgreSQL psql launch script for Linux
# Dave Page, EnterpriseDB

for shell in xterm konsole gnome-terminal
do
    which $shell > /dev/null 2>&1
    if [ $? -eq 0 ];
    then
        if [ x"$shell" = x"konsole" ]
        then
            `which konsole` -e "PG_INSTALLDIR/scripts/runpsql.sh" wait
        else
            `which $shell` -e "PG_INSTALLDIR/scripts/runpsql.sh wait"
        fi
        exit 0
    fi
done

