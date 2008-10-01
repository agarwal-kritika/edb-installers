#!/bin/bash

    
################################################################################
# Build preparation
################################################################################

_prep_pgJDBC_linux_x64() {

    # Enter the source directory and cleanup if required
    cd $WD/pgJDBC/source

    if [ -e pgJDBC.linux-x64 ];
    then
      echo "Removing existing pgJDBC.linux-x64 source directory"
      rm -rf pgJDBC.linux-x64  || _die "Couldn't remove the existing pgJDBC.linux-x64 source directory (source/pgJDBC.linux-x64)"
    fi
   
    echo "Creating staging directory ($WD/pgJDBC/source/pgJDBC.linux-x64)"
    mkdir -p $WD/pgJDBC/source/pgJDBC.linux-x64 || _die "Couldn't create the pgJDBC.linux-x64 directory"

    # Grab a copy of the source tree
    cp -R pgJDBC-$PG_VERSION_PGJDBC/* pgJDBC.linux-x64 || _die "Failed to copy the source code (source/pgJDBC-$PG_VERSION_PGJDBC)"
    chmod -R ugo+w pgJDBC.linux-x64 || _die "Couldn't set the permissions on the source directory"

    # Remove any existing staging directory that might exist, and create a clean one
    if [ -e $WD/pgJDBC/staging/linux-x64 ];
    then
      echo "Removing existing staging directory"
      rm -rf $WD/pgJDBC/staging/linux-x64 || _die "Couldn't remove the existing staging directory"
    fi

    echo "Creating staging directory ($WD/pgJDBC/staging/linux-x64)"
    mkdir -p $WD/pgJDBC/staging/linux-x64 || _die "Couldn't create the staging directory"
    chmod ugo+w $WD/pgJDBC/staging/linux-x64 || _die "Couldn't set the permissions on the staging directory"
    

}

################################################################################
# PG Build
################################################################################

_build_pgJDBC_linux_x64() {

    cd $WD
}


################################################################################
# PG Build
################################################################################

_postprocess_pgJDBC_linux_x64() {
 
    cp -R $WD/pgJDBC/source/pgJDBC.linux-x64/* $WD/pgJDBC/staging/linux-x64 || _die "Failed to copy the pgJDBC Source into the staging directory"

    cd $WD/pgJDBC

    # Setup the installer scripts.
    mkdir -p staging/linux-x64/installer/pgjdbc || _die "Failed to create a directory for the install scripts"
    cp scripts/linux-x64/removeshortcuts.sh staging/linux-x64/installer/pgjdbc/removeshortcuts.sh || _die "Failed to copy the removeshortcuts script (scripts/linux-x64/removeshortcuts.sh)"
    chmod ugo+x staging/linux-x64/installer/pgjdbc/removeshortcuts.sh

    cp scripts/linux-x64/createshortcuts.sh staging/linux-x64/installer/pgjdbc/createshortcuts.sh || _die "Failed to copy the createshortcuts.sh script (scripts/linux-x64/createshortcuts.sh)"
    chmod ugo+x staging/linux-x64/installer/pgjdbc/createshortcuts.sh

    # Setup Launch Scripts
    mkdir -p staging/linux-x64/scripts || _die "Failed to create a directory for the launch scripts"
    cp scripts/linux-x64/launchbrowser.sh staging/linux-x64/scripts/launchbrowser.sh || _die "Failed to copy the launchbrowser script (scripts/linux-x64/launchbrowser.sh)"
    chmod ugo+x staging/linux-x64/scripts/launchbrowser.sh

    # Setup the pgJDBC xdg Files
    mkdir -p staging/linux-x64/scripts/xdg || _die "Failed to create a directory for the launch scripts"
    cp resources/xdg/enterprisedb-launchpgJDBC.desktop staging/linux-x64/scripts/xdg/enterprisedb-launchpgJDBC.desktop || _die "Failed to copy the xdg files "
    chmod ugo+x staging/linux-x64/scripts/xdg/enterprisedb-launchpgJDBC.desktop

    cp resources/xdg/enterprisedb-postgres.directory staging/linux-x64/scripts/xdg/enterprisedb-postgres.directory || _die "Failed to copy the xdg files "
    chmod ugo+x staging/linux-x64/scripts/xdg/enterprisedb-postgres.directory

    # Copy in the menu pick images
    mkdir -p staging/linux-x64/scripts/images || _die "Failed to create a directory for the menu pick images"
    cp resources/*.png staging/linux-x64/scripts/images || _die "Failed to copy the menu pick images (resources/*.png)"

    mkdir -p staging/linux-x64/installer/xdg || _die "Failed to create a directory for the menu pick xdg files"
    
    # Copy in installation xdg Files
    cp -R $WD/scripts/xdg/xdg* staging/linux-x64/installer/xdg || _die "Failed to copy the xdg files "
     
    # Build the installer
    "$PG_INSTALLBUILDER_BIN" build installer.xml linux-x64 || _die "Failed to build the installer"

    cd $WD
}

