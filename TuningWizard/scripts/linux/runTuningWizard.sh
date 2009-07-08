#!/bin/sh

# PostgreSQL tuning-wizard runner script for Linux
# Dave Page, EnterpriseDB
LOADINGUSER=`whoami`
echo "NOTE: Graphical administrator tool for su/sudo could not be located on your system! This window must be kept open, while the Tuning-Wizard is running."

# You're not running this script as root user
if [ x"$LOADINGUSER" != x"root" ];
then

    USE_SUDO=0

    if [ -f /etc/lsb-release ];
    then
        if [ `grep -E '^DISTRIB_ID=[a-zA-Z]?buntu$' /etc/lsb-release | wc -l` != "0" ];
        then
            USE_SUDO=1
        fi
    fi

    if [ $USE_SUDO != "1" ];
    then
        if [ x"$LOADINGUSER" != x"root" ];
        then
            echo "Please enter the root password when requested."
        fi
    else
        echo "Please enter your password if requested."
    fi

    if [ $USE_SUDO = "1" ];
    then
        sudo su -c "LD_LIBRARY_PATH="INSTALLDIR/lib":$LD_LIBRARY_PATH G_SLICE=always-malloc "INSTALLDIR/TuningWizard""
    elif [ $USE_SUDO != "1" ];
    then
        su -c "LD_LIBRARY_PATH="INSTALLDIR/lib":$LD_LIBRARY_PATH G_SLICE=always-malloc "INSTALLDIR/TuningWizard""
    fi

else
    LD_LIBRARY_PATH="INSTALLDIR/lib":$LD_LIBRARY_PATH G_SLICE=always-malloc "INSTALLDIR/TuningWizard"
fi

