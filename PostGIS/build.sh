#!/bin/bash

# Read the various build scripts

# Mac OS X
if [ $PG_ARCH_OSX = 1 ]; 
then
    source $WD/PostGIS/build-osx.sh
fi

# Linux
if [ $PG_ARCH_LINUX = 1 ];
then
    source $WD/PostGIS/build-linux.sh
fi

# Linux x64
if [ $PG_ARCH_LINUX_X64 = 1 ];
then
    source $WD/PostGIS/build-linux-x64.sh
fi

# Linux ppc64
if [ $PG_ARCH_LINUX_PPC64 = 1 ];
then
    source $WD/PostGIS/build-linux-ppc64.sh
fi

# Windows
if [ $PG_ARCH_WINDOWS = 1 ];
then
    source $WD/PostGIS/build-windows.sh
fi

    
################################################################################
# Build preparation
################################################################################

_prep_PostGIS() {

    # Create the source directory if required
    if [ ! -e $WD/PostGIS/source ];
    then
        mkdir $WD/PostGIS/source
    fi


    # Enter the source directory and cleanup if required
    cd $WD/PostGIS/source

    #postgresql for windows
    if [ ! -e postgresql-$PG_TARBALL_POSTGRESQL ];
    then
      extract_file  ../../tarballs/postgresql-$PG_TARBALL_POSTGRESQL || exit 1
      cd postgresql-$PG_TARBALL_POSTGRESQL
      patch -p0 < ../../../tarballs/mingw_build.patch
    fi

    cd $WD/PostGIS/source

    # postgis
    if [ -e postgis-$PG_VERSION_POSTGIS ];
    then
      echo "Removing existing postgis-$PG_VERSION_POSTGIS source directory"
      rm -rf postgis-$PG_VERSION_POSTGIS  || _die "Couldn't remove the existing postgis-$PG_VERSION_POSTGIS source directory (source/postgis-$PG_VERSION_POSTGIS)"
    fi

    echo "Unpacking postgis source..."
    extract_file  ../../tarballs/postgis-$PG_VERSION_POSTGIS || exit 1
  
    cd $WD/PostGIS/source  

    # geos
    if [ -e geos-$PG_TARBALL_GEOS ];
    then
      echo "Removing existing geos-$PG_TARBALL_GEOS source directory"
      rm -rf geos-$PG_TARBALL_GEOS || _die "Couldn't remove the existing geos-$PG_TARBALL_GEOS source directory (source/geos-$PG_TARBALL_GEOS)"
    fi

    echo "Unpacking geos source..."
    extract_file  ../../tarballs/geos-$PG_TARBALL_GEOS || exit 1 

    # proj
    if [ -e proj-$PG_TARBALL_PROJ ];
    then
      echo "Removing existing proj-$PG_TARBALL_PROJ source directory"
      rm -rf proj-$PG_TARBALL_PROJ  || _die "Couldn't remove the existing proj-$PG_TARBALL_PROJ source directory (source/proj-$PG_TARBALL_PROJ)"
    fi

    echo "Unpacking proj source..."
    extract_file  ../../tarballs/proj-$PG_TARBALL_PROJ || exit 1 

    echo "Extracting the postgresql jar file..."
    extract_file  ../../tarballs/pgJDBC-$PG_VERSION_PGJDBC || exit 1 
    mv pgJDBC-$PG_VERSION_PGJDBC/*.jar .

    # Per-platform prep
    cd $WD
    
    # Mac OS X
    if [ $PG_ARCH_OSX = 1 ]; 
    then
        _prep_PostGIS_osx || exit 1
    fi

    # Linux
    if [ $PG_ARCH_LINUX = 1 ];
    then
        _prep_PostGIS_linux || exit 1
    fi

    # Linux x64
    if [ $PG_ARCH_LINUX_X64 = 1 ];
    then
        _prep_PostGIS_linux_x64 || exit 1
    fi

    # Linux ppc64
    if [ $PG_ARCH_LINUX_PPC64 = 1 ];
    then
        #_prep_PostGIS_linux_ppc64 || exit 1
        echo "Linux-PPC64 build pre-process is not part of build framework yet."
    fi

    # Windows
    if [ $PG_ARCH_WINDOWS = 1 ];
    then
        #_prep_PostGIS_windows || exit 1
        echo "PostGIS:Disabled for now:windows"
    fi
    
}

################################################################################
# Build PostGIS
################################################################################

_build_PostGIS() {

    # Mac OSX
    if [ $PG_ARCH_OSX = 1 ]; 
    then
        _build_PostGIS_osx || exit 1
    fi

    # Linux 
    if [ $PG_ARCH_LINUX = 1 ];
    then
        _build_PostGIS_linux || exit 1
    fi

    # Linux x64
    if [ $PG_ARCH_LINUX_X64 = 1 ];
    then
        _build_PostGIS_linux_x64 || exit 1
    fi

    # Linux ppc64
    if [ $PG_ARCH_LINUX_PPC64 = 1 ];
    then
        #_build_PostGIS_linux_ppc64 || exit 1
        echo "Linux-PPC64 build process is not part of build framework yet."
    fi

    # Windows
#    if [ $PG_ARCH_WINDOWS = 1 ];
#    then
#        _build_PostGIS_windows || exit 1
#    fi
}

################################################################################
# Postprocess PostGIS
################################################################################
#
# Note that this is the only step run if we're executed with -skipbuild so it must
# be possible to run this against a pre-built tree.
_postprocess_PostGIS() {

    cd $WD/PostGIS


    # Prepare the installer XML file
    if [ -f installer.xml ];
    then
        rm installer.xml
    fi
    cp installer.xml.in installer.xml || _die "Failed to copy the installer project file (PostGIS/installer.xml.in)"

    PG_CURRENT_VERSION=`echo $PG_MAJOR_VERSION | sed -e 's/\.//'`

    PG_GEOS_DLL_VERSION=`echo $PG_TARBALL_GEOS | sed -e 's:\.:-:g'`

    POSTGIS_MAJOR_VERSION=`echo $PG_VERSION_POSTGIS | cut -f1,2 -d "."`

    _replace PG_VERSION_POSTGIS "$PG_VERSION_POSTGIS" installer.xml || _die "Failed to set the major version in the installer project file (PostGIS/installer.xml)"

    _replace PG_TARBALL_GEOS $PG_TARBALL_GEOS installer.xml || _die "Failed to set the major version of geos in the installer project file (PostGIS/installer.xml)"
    
    _replace PG_BUILDNUM_POSTGIS $PG_BUILDNUM_POSTGIS installer.xml || _die "Failed to set Build Number in the installer project file (PostGIS/installer.xml)"

    _replace PG_CURRENT_VERSION $PG_CURRENT_VERSION installer.xml || _die "Failed to set the PG Current Number in the installer project file (PostGIS/installer.xml)"
    
    _replace PG_MAJOR_VERSION $PG_MAJOR_VERSION installer.xml || _die "Failed to set the PG MAJOR Number in the installer project file (PostGIS/installer.xml)"
    _replace PG_GEOS_DLL_VERSION $PG_GEOS_DLL_VERSION installer.xml || _die "Failed to set the PG MAJOR Number in the installer project file (PostGIS/installer.xml)"
    _replace POSTGIS_MAJOR_VERSION $POSTGIS_MAJOR_VERSION installer.xml || _die "Failed to set the POSTGIS MAJOR Number in the installer project file (PostGIS/installer.xml)"

    # Mac OSX
    if [ $PG_ARCH_OSX = 1 ]; 
    then
        _postprocess_PostGIS_osx || exit 1
    fi

    # Linux
    if [ $PG_ARCH_LINUX = 1 ];
    then
        _postprocess_PostGIS_linux || exit 1
    fi

    # Linux x64
    if [ $PG_ARCH_LINUX_X64 = 1 ];
    then
        _postprocess_PostGIS_linux_x64 || exit 1
    fi
    
    # Linux ppc64
    if [ $PG_ARCH_LINUX_PPC64 = 1 ];
    then
        _postprocess_PostGIS_linux_ppc64 || exit 1
    fi
    
    # Windows
#    if [ $PG_ARCH_WINDOWS = 1 ];
#    then
#        _postprocess_PostGIS_windows || exit 1
#    fi
}

