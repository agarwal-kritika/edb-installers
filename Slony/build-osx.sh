#!/bin/bash

    
################################################################################
# Build preparation
################################################################################

_prep_Slony_osx() {
      
    # Enter the source directory and cleanup if required
    cd $WD/Slony/source

    if [ -e slony.osx ];
    then
      echo "Removing existing slony.osx source directory"
      rm -rf slony.osx  || _die "Couldn't remove the existing slony.osx source directory (source/slony.osx)"
    fi

    echo "Creating slony source directory ($WD/Slony/source/slony.osx)"
    mkdir -p slony.osx || _die "Couldn't create the slony.osx directory"
    chmod ugo+w slony.osx || _die "Couldn't set the permissions on the source directory"

    # Grab a copy of the slony source tree
    cp -R slony1-$PG_VERSION_SLONY/* slony.osx || _die "Failed to copy the source code (source/slony1-$PG_VERSION_SLONY)"
    chmod -R ugo+w slony.osx || _die "Couldn't set the permissions on the source directory"

    # Remove any existing staging directory that might exist, and create a clean one
    if [ -e $WD/Slony/staging/osx ];
    then
      echo "Removing existing staging directory"
      rm -rf $WD/Slony/staging/osx || _die "Couldn't remove the existing staging directory"
    fi

    echo "Creating staging directory ($WD/Slony/staging/osx)"
    mkdir -p $WD/Slony/staging/osx || _die "Couldn't create the staging directory"
    chmod ugo+w $WD/Slony/staging/osx || _die "Couldn't set the permissions on the staging directory"

    echo "Removing existing slony files from the PostgreSQL directory"
    cd $PG_PGHOME_OSX
    rm -f bin/slon bin/slonik bin/slony_logshipper lib/postgresql/slony_funcs.so lib/postgresql/xxid.so"  || _die "Failed to remove slony binary files"
    rm -f share/postgresql/slony*.sql && rm -f share/postgresql/xxid*.sql"  || _die "remove slony share files"
}


################################################################################
# PG Build
################################################################################

_build_Slony_osx() {

    # build slony
    PG_STAGING=$PG_PATH_OSX/Slony/staging/osx

    echo "Configuring the slony source tree"
    cd $PG_PATH_OSX/Slony/source/slony.osx/
    CFLAGS="$PG_ARCH_OSX_CFLAGS -arch ppc -arch i386" LDFLAGS="-lssl" PATH="$PG_PGHOME_OSX/bin:$PATH" ./configure --disable-dependency-tracking --prefix=$PG_PGHOME_OSX --with-pgconfigdir=$PG_PGHOME_OSX/bin  || _die "Failed to configure slony"

    echo "Building slony"
    cd $PG_PATH_OSX/Slony/source/slony.osx
    make || _die "Failed to build slony"

    echo "Hacking xxid.so & slony1_funcs.so as it bundles only i386 version on Intel machine"
    if [ -e $PG_PATH_OSX/Slony/source/slony.osx/src/xxid ]; then
        cd $PG_PATH_OSX/Slony/source/slony.osx/src/xxid
        if [ -e xxid.so ]; then
            echo "Removing existing xxid.so"
            rm -f xxid.so || _die "Couldn't remove xxid.so"
        fi
        if [ -e xxid.o ]; then
            echo "Recreate xxid.so with both i386 & ppc architecture"
            gcc $PG_ARCH_OSX_CFLAGS -arch ppc -arch i386 -bundle -o xxid.so xxid.o -bundle_loader $PG_PGHOME_OSX/bin/postgres || _die "Couldn't create the hacked xxid.so"
        fi
    fi
    if [ -e $PG_PATH_OSX/Slony/source/slony.osx/src/backend ]; then
        cd $PG_PATH_OSX/Slony/source/slony.osx/src/backend
        if [ -e slony1_funcs.so ]; then
            echo "Removing existing slony1_funcs.so"
            rm -f slony1_funcs.so || _die "Couldn't remove slony_funcs.so"
        fi
        if [ -e slony1_funcs.o ]; then
            echo "Recreate slony1_funcs.so for both i386 & ppc architecture"
            gcc $PG_ARCH_OSX_CFLAGS -arch ppc -arch i386 -bundle -o slony1_funcs.so slony1_funcs.o -bundle_loader $PG_PGHOME_OSX/bin/postgres || _die "Couldn't create the hacked slony1_funcs.so"
        fi
    fi

 
    cd $PG_PATH_OSX/Slony/source/slony.osx
    make install || _die "Failed to install slony"

    # Slony installs it's files into postgresql directory
    # We need to copy them to staging directory

    mkdir -p $WD/Slony/staging/osx/bin
    cp $PG_PGHOME_OSX/bin/slon $PG_STAGING/bin || _die "Failed to copy slon binary to staging directory"
    cp $PG_PGHOME_OSX/bin/slonik $PG_STAGING/bin || _die "Failed to copy slonik binary to staging directory"
    cp $PG_PGHOME_OSX/bin/slony_logshipper $PG_STAGING/bin || _die "Failed to copy slony_logshipper binary to staging directory"

    mkdir -p $WD/Slony/staging/osx/lib
    cp $PG_PGHOME_OSX/lib/postgresql/slony1_funcs.so $PG_STAGING/lib || _die "Failed to copy slony_funcs.so to staging directory"
    cp $PG_PGHOME_OSX/lib/postgresql/xxid.so $PG_STAGING/lib || _die "Failed to copy xxid.so to staging directory"

    mkdir -p $WD/Slony/staging/osx/Slony
    cp $PG_PGHOME_OSX/share/postgresql/slony*.sql $PG_STAGING/Slony || _die "Failed to share files to staging directory"
    cp $PG_PGHOME_OSX/share/postgresql/xxid.*.sql $PG_STAGING/Slony || _die "Failed to share files to staging directory"


    # Rewrite shared library references (assumes that we only ever reference libraries in lib/)
    _rewrite_so_refs $WD/Slony/staging/osx lib @loader_path/..
    _rewrite_so_refs $WD/Slony/staging/osx bin @loader_path/..


}


################################################################################
# PG Build
################################################################################

_postprocess_Slony_osx() {

    PG_STAGING=$PG_PATH_OSX/Slony/staging/osx

    cd $WD/Slony

    mkdir -p staging/osx/installer/Slony || _die "Failed to create a directory for the install scripts"
    cp scripts/osx/createshortcuts.sh staging/osx/installer/Slony/createshortcuts.sh || _die "Failed to copy the createshortcuts script (scripts/osx/createshortcuts.sh)"
    chmod ugo+x staging/osx/installer/Slony/createshortcuts.sh

    cp scripts/osx/configureslony.sh staging/osx/installer/Slony/configureslony.sh || _die "Failed to copy the createshortcuts script (scripts/osx/configureslony.sh)"
    chmod ugo+x staging/osx/installer/Slony/configureslony.sh

    mkdir -p staging/osx/scripts || _die "Failed to create a directory for the launch scripts"
    cp -R scripts/osx/launchbrowser.sh staging/osx/scripts/launchbrowser.sh || _die "Failed to copy the launch scripts (scripts/osx)"
    chmod ugo+x staging/osx/scripts/launchbrowser.sh
    cp -R scripts/osx/enterprisedb-launchSlonyDocs.applescript.in staging/osx/scripts/enterprisedb-launchSlonyDocs.applescript || _die "Failed to copy the launch script (scripts/osx/enterprisedb-launchSlonyDocs.applescript.in)"
    chmod ugo+x staging/osx/scripts/enterprisedb-launchSlonyDocs.applescript

    # Copy in the menu pick images and XDG items
    mkdir -p staging/osx/scripts/images || _die "Failed to create a directory for the menu pick images"
    cp resources/enterprisedb-launchSlonyDocs.icns staging/osx/scripts/images || _die "Failed to copy the menu pick images (resources/enterprisedb-launchSlonyDocs.icns)"

    # Build the installer
    "$PG_INSTALLBUILDER_BIN" build installer.xml osx || _die "Failed to build the installer"

    # Now we need to turn this into a DMG file
    echo "Creating disk image"
    cd $WD/output
    if [ -d slony.img ];
    then
        rm -rf slony.img
    fi
    mkdir slony.img || _die "Failed to create DMG staging directory"
    mv slony_I_PG$PG_CURRENT_VERSION-$PG_VERSION_SLONY-$PG_BUILDNUMSLONY-osx.app slony.img || _die "Failed to copy the installer bundle into the DMG staging directory"
    hdiutil create -quiet -srcfolder slony.img -format UDZO -volname "Slony $PG_VERSION_SLONY" -ov "slony_I_PG$PG_CURRENT_VERSION-$PG_VERSION_SLONY-$PG_BUILDNUMSLONY-osx.dmg" || _die "Failed to create the disk image (output/slony_I_PG$PG_CURRENT_VERSION-$PG_VERSION_SLONY-$PG_BUILDNUMSLONY-osx.dmg)"
    rm -rf slony.img
 
    
    cd $WD
}

