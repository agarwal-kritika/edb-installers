#!/bin/bash

# Read the various build scripts

# Mac OS X
if [ $PG_ARCH_OSX = 1 ]; 
then
   source $WD/pgAgent/build-osx.sh
fi

# Windows-x64
if [ $PG_ARCH_WINDOWS_X64 = 1 ];
then
    source $WD/pgAgent/build-windows-x64.sh
fi
    
################################################################################
# Build preparation
################################################################################

_prep_pgAgent() {

    # Create the source directory if required
    if [ ! -e $WD/pgAgent/source ];
    then
        mkdir $WD/pgAgent/source
    fi
    
    # Enter the source directory and cleanup if required
    cd $WD/pgAgent/source

    # pgAgent
    if [ -e pgAgent-$PG_VERSION_PGAGENT-Source ];
    then
      echo "Removing existing pgAgent-$PG_VERSION_PGAGENT-Source source directory"
      rm -rf pgAgent-$PG_VERSION_PGAGENT-Source  || _die "Couldn't remove the existing pgAgent-$PG_VERSION_PGAGENT-Source source directory (source/pgAgent-$PG_VERSION_PGAGENT-Source)"
    fi

    echo "Unpacking pgAgent source..."
    extract_file  ../../tarballs/pgAgent-$PG_VERSION_PGAGENT-Source 
    cd pgAgent-$PG_VERSION_PGAGENT-Source
    #patch -p1 < $WD/tarballs/pgAgent-Lion.patch # This is not required to build pgAgent3.3.0. Hence, commenting this.
    
    # Per-platform prep
    cd $WD
    
    # Mac OS X
    if [ $PG_ARCH_OSX = 1 ]; 
    then
       _prep_pgAgent_osx 
    fi

    # Windows_x64
    if [ $PG_ARCH_WINDOWS_X64 = 1 ];
    then
        _prep_pgAgent_windows_x64
    fi
    
}

################################################################################
# Build pgAgent
################################################################################

_build_pgAgent() {

    # Mac OSX
    if [ $PG_ARCH_OSX = 1 ]; 
    then
       _build_pgAgent_osx 
    fi

    # Windows_x64
    if [ $PG_ARCH_WINDOWS_X64 = 1 ];
    then
        _build_pgAgent_windows_x64
    fi
}

################################################################################
# Postprocess pgAgent
################################################################################
#
# Note that this is the only step run if we're executed with -skipbuild so it must
# be possible to run this against a pre-built tree.
_postprocess_pgAgent() {

    cd $WD/pgAgent


    # Prepare the installer XML file
    if [ -f installer.xml ];
    then
        rm installer.xml
    fi

    cp installer.xml.in installer.xml || _die "Failed to copy the installer project file (pgAgent/installer.xml.in)"

     PG_CURRENT_VERSION=`echo $PG_MAJOR_VERSION | sed -e 's/\.//'`

     PGAGENT_MAJOR_VERSION=`echo $PG_VERSION_PGAGENT | cut -f1,2 -d "."`
     PGAGENT_SERVICE_NAME=pgagent-pg$PG_MAJOR_VERSION

    _replace PG_VERSION_PGAGENT $PG_VERSION_PGAGENT installer.xml || _die "Failed to set the version in the installer project file (pgAgent/installer.xml)"
    _replace PG_BUILDNUM_PGAGENT $PG_BUILDNUM_PGAGENT installer.xml || _die "Failed to set the Build Number in the installer project file (pgAgent/installer.xml)"

    _replace PG_CURRENT_VERSION $PG_CURRENT_VERSION installer.xml || _die "Failed to set the PG Current Number in the installer project file (PostGIS/installer.xml)"
    _replace PG_MAJOR_VERSION $PG_MAJOR_VERSION installer.xml || _die "Failed to set the PG MAJOR Number in the installer project file (PostGIS/installer.xml)"
    _replace PGAGENT_MAJOR_VERSION $PGAGENT_MAJOR_VERSION installer.xml || _die "Failed to set the PGAGENT MAJOR Number in the installer project file (PostGIS/installer.xml)"
    _replace PGAGENT_SERVICE_NAME $PGAGENT_SERVICE_NAME installer.xml || _die "Failed to set the PGAGENT SERVICE NAME in the installer project file (PostGIS/installer.xml)"

    # Mac OSX
    if [ $PG_ARCH_OSX = 1 ]; 
    then
       _postprocess_pgAgent_osx 
    fi

    # Windows_x64
    if [ $PG_ARCH_WINDOWS_X64 = 1 ];
    then
        _postprocess_pgAgent_windows_x64
    fi
}
