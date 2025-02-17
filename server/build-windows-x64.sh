#!/bin/bash

    
################################################################################
# Build preparation
################################################################################

_prep_server_windows_x64() {
    # Following echo statement for Jenkins Console Section output
    echo "BEGIN PREP Server Windows-x64"

    # Enter the source directory and cleanup if required
    cd $WD/server/source
    
    if [ -e postgres.windows-x64 ];
    then
        echo "Removing existing postgres.windows-x64 source directory"
        rm -rf postgres.windows-x64  || _die "Couldn't remove the existing postgres.windows-x64 source directory (source/postgres.windows-x64)"
    fi
    if [ -e pgadmin.windows-x64 ];
    then
        echo "Removing existing pgadmin.windows-x64 source directory"
        rm -rf pgadmin.windows-x64  || _die "Couldn't remove the existing pgadmin.windows-x64 source directory (source/pgadmin.windows-x64)"
    fi
    if [ -e stackbuilder.windows-x64 ];
    then
        echo "Removing existing stackbuilder.windows-x64 source directory"
        rm -rf stackbuilder.windows-x64  || _die "Couldn't remove the existing stackbuilder.windows-x64 source directory (source/stackbuilder.windows-x64)"
    fi
    if [ -e system_stats.windows-x64 ];
    then
        echo "Removing existing system_stats.windows-x64 source directory"
        rm -rf system_stats.windows-x64  || _die "Couldn't remove the existing system_stats.windows-x64 source directory (source/system_stats.windows-x64)"
    fi
    
    # Remove any existing zip files
    if [ -f $WD/server/source/postgres-win64.zip ];
    then
        echo "Removing existing source archive"
        rm -rf $WD/server/source/postgres-win64.zip || _die "Couldn't remove the existing source archive"
    fi
    if [ -f $WD/server/source/pgadmin-win64.zip ];
    then
        echo "Removing existing pgadmin archive"
        rm -rf $WD/server/source/pgadmin-win64.zip || _die "Couldn't remove the existing pgadmin archive"
    fi
    if [ -f $WD/server/source/stackbuilder-win64.zip ];
    then
        echo "Removing existing stackbuilder archive"
        rm -rf $WD/server/source/stackbuilder-win64.zip || _die "Couldn't remove the existing stackbuilder archive"
    fi
    if [ -f $WD/server/source/system_stats-win64.zip ];
    then
        echo "Removing existing system_stats archive"
        rm -rf $WD/server/source/system_stats-win64.zip || _die "Couldn't remove the existing system_stats archive"
    fi
    if [ -f $WD/server/scripts/windows/scripts.zip ];
    then
        echo "Removing existing scripts archive"
        rm -rf $WD/server/scripts/windows/scripts.zip || _die "Couldn't remove the existing scripts archive"
    fi
    if [ -f $WD/server/staging/windows-x64/output.zip ];
    then
        echo "Removing existing output archive"
        rm -rf $WD/server/staging/windows-x64/output.zip || _die "Couldn't remove the existing output archive"
    fi
    
    # Cleanup the build host
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q postgres-win64.zip"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q pgadmin-win64.zip"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q stackbuilder-win64.zip"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q system_stats-win64.zip"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q scripts.zip"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; rm -rf output.zip"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q vc-build-x64.bat"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q vc-build.bat"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q vc-build-doc.bat"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q build-pgadmin4.bat"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c del /S /Q vc-build-sys-stat.bat"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; rm -rf output.build"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c rd /S /Q postgres.windows-x64"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; rm -rf pgadmin.windows-x64"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c rd /S /Q stackbuilder.windows-x64"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c rd /S /Q system_stats.windows-x64"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c rd /S /Q createuser"    
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c rd /S /Q getlocales"    
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c rd /S /Q validateuser"
    
    # Cleanup local files
    if [ -f $WD/server/scripts/windows/vc-build.bat ];
    then
        echo "Removing existing vc-build script"
        rm -rf $WD/server/scripts/windows/vc-build.bat || _die "Couldn't remove the existing vc-build script"
    fi

    if [ -f $WD/server/scripts/windows/vc-build-x64.bat ];
    then
        echo "Removing existing vc-build-x64 script"
        rm -rf $WD/server/scripts/windows/vc-build-x64.bat || _die "Couldn't remove the existing vc-build-x64 script"
    fi

    if [ -f $WD/server/scripts/windows/vc-build-doc.bat ];
    then
        echo "Removing existing vc-build-doc script"
        rm -rf $WD/server/scripts/windows/vc-build-doc.bat || _die "Couldn't remove the existing vc-build-doc script"
    fi

    if [ -f $WD/server/scripts/windows/vc-build-sys-stat.bat ];
    then
        echo "Removing existing vc-build-sys-stat.bat script"
        rm -rf $WD/server/scripts/windows/vc-build-sys-stat.bat || _die "Couldn't remove the existing vc-build-sys-stat.bat script"
    fi
    # Grab a copy of the source tree
    cp -R postgresql-$PG_TARBALL_POSTGRESQL postgres.windows-x64 || _die "Failed to copy the source code (source/postgres.windows-x64)"

    cp -R pgadmin4-$PG_TARBALL_PGADMIN pgadmin.windows-x64 || _die "Failed to copy the source code (source/pgadmin.windows-x64)"

    cd $WD/server/source
    cp -R stackbuilder stackbuilder.windows-x64 || _die "Failed to copy the source code (source/stackbuilder.windows-x64)"

    cd stackbuilder.windows-x64
    patch -p1 < $WD/../patches/sb_patch_for_pg.patch   
    cd $WD/server/source
 
    cp -R system_stats system_stats.windows-x64 || _die "Failed to copy the source code (source/system_stats.windows-x64)"

    # Remove any existing staging directory that might exist, and create a clean one
    if [ -e $WD/server/staging_cache/windows-x64 ];
    then
        echo "Removing existing staging_cache directory"
        rm -rf $WD/server/staging_cache/windows-x64 || _die "Couldn't remove the existing staging_cache directory"
    fi

    echo "Creating staging_cache directory ($WD/server/staging_cache/windows-x64)"
    mkdir -p $WD/server/staging_cache/windows-x64 || _die "Couldn't create the staging_cache directory"

    if [ -e $WD/server/staging/windows-x64 ];
    then
        echo "Removing existing staging directory"
        rm -rf $WD/server/staging/windows-x64 || _die "Couldn't remove the existing staging directory"
    fi

    echo "Creating staging directory ($WD/server/staging/windows-x64_restructured)"
    mkdir -p $WD/server/staging/windows-x64 || _die "Couldn't create the staging directory"

    echo "END PREP Server Windows-x64"
}

################################################################################
# Build
################################################################################

_build_server_windows_x64() {
    echo "BEGIN BUILD Server Windows-x64"
    
    # Create a build script for VC++
    cd $WD/server/scripts/windows
    cat <<EOT > "vc-build.bat"
REM Setting Visual Studio Environment
CALL "$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Auxiliary\Build\vcvarsall.bat" x86

@SET PGBUILD=$PG_PGBUILD_WINDOWS
@SET OPENSSL=$PG_PGBUILD_WINDOWS
@SET WXWIN=$PG_WXWIN_WINDOWS
@SET INCLUDE=$PG_PGBUILD_WINDOWS\\include;%INCLUDE%
@SET LIB=$PG_PGBUILD_WINDOWS\\lib;%LIB%
@SET PGDIR=$PG_PATH_WINDOWS\\output.build
@SET SPHINXBUILD=$PG_PYTHON_WINDOWS_X64\\Scripts\\sphinx-build.exe

IF "%2" == "UPGRADE" GOTO upgrade

msbuild %1 /p:Configuration=%2 %3
GOTO end

:upgrade
devenv /upgrade %1

:end

EOT

    cat <<EOT > "vc-build-x64.bat"
REM Setting Visual Studio Environment
CALL "$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Auxiliary\Build\vcvarsall.bat" amd64

@SET PGBUILD=$PG_PGBUILD_WINDOWS_X64
@SET OPENSSL=$PG_PGBUILD_WINDOWS_X64
@SET WXWIN=$PG_WXWIN_WINDOWS_X64
@SET INCLUDE=$PG_PGBUILD_WINDOWS_X64\\include;%INCLUDE%
@SET LIB=$PG_PGBUILD_WINDOWS_X64\\lib;%LIB%
@SET PGDIR=$PG_PATH_WINDOWS_X64\\output.build
@SET SPHINXBUILD=$PG_PYTHON_WINDOWS_X64\\Scripts\\sphinx-build.exe

REM batch file splits single argument containing "=" sign into two
REM Following code handles this scenario

IF "%2" == "UPGRADE" GOTO upgrade
IF "%~3" == "" ( SET VAR3=""
) ELSE (
SET VAR3="%3=%4"
)
msbuild %1 /p:Configuration=%2 %VAR3%
GOTO end

:upgrade
devenv /upgrade %1

:end

EOT

cat <<EOT > "vc-build-doc.bat"
REM Setting Visual Studio Environment
CALL "$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Auxiliary\Build\vcvarsall.bat" x86

@SET PGBUILD=$PG_PGBUILD_WINDOWS_X64
@SET OPENSSL=$PG_PGBUILD_WINDOWS_X64
@SET WXWIN=$PG_WXWIN_WINDOWS_X64
@SET INCLUDE=$PG_PGBUILD_WINDOWS_X64\\include;%INCLUDE%
@SET LIB=$PG_PGBUILD_WINDOWS_X64\\lib;%LIB%
@SET PGDIR=$PG_PATH_WINDOWS_X64\\output.build
@SET SPHINXBUILD=$PG_PYTHON_WINDOWS_X64\\Scripts\\sphinx-build.exe

REM batch file splits single argument containing "=" sign into two
REM Following code handles this scenario

IF "%2" == "UPGRADE" GOTO upgrade
IF "%~3" == "" ( SET VAR3=""
) ELSE (
SET VAR3="%3=%4"
)
msbuild %1 /p:Configuration=%2 %VAR3%
GOTO end

:upgrade
devenv /upgrade %1

:end

EOT

cat <<EOT > "vc-build-sys-stat.bat"
REM Setting Visual Studio Environment
CALL "$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Auxiliary\Build\vcvarsall.bat" amd64
REM CALL "$PG_VSINSTALLDIR_WINDOWS_X64\VC\vcvarsall.bat" amd64
@SET PG_INCLUDE_DIR=$PG_PGBUILD_WINDOWS_X64\\include;$PG_PATH_WINDOWS_X64\\postgres.windows-x64\src\include
@SET PG_LIB_DIR=$PG_PATH_WINDOWS_X64\postgres.windows-x64\Release\postgres

REM batch file splits single argument containing "=" sign into two
REM Following code handles this scenario

IF "%2" == "UPGRADE" GOTO upgrade
IF "%~3" == "" ( SET VAR3=""
) ELSE (
SET VAR3="%3=%4"
)
msbuild %1 /p:Configuration=%2 %VAR3%
GOTO end

:upgrade
devenv /upgrade %1

:end

EOT
 
    # Copy in an appropriate config.pl and buildenv.pl
    cd $WD/server/source/
    cat <<EOT > "postgres.windows-x64/src/tools/msvc/config.pl"
# Configuration arguments for vcbuild.
use strict;
use warnings;

our \$config = {
    asserts=>0,                         # --enable-cassert
    nls=>'$PG_PGBUILD_GETTEXT_WINDOWS_X64',        # --enable-nls=<path>
    perl=>'$PG_PERL_WINDOWS_X64',             # --with-perl
    python=>'$PG_PYTHON_WINDOWS_X64',         # --with-python=<path>
    tcl=>'$PG_TCL_WINDOWS_X64',            # --with-tls=<path>
    ldap=>1,                # --with-ldap
    openssl=>'$PG_PGBUILD_WINDOWS_X64',     # --with-ssl=<path>
    xml=>'$PG_PGBUILD_WINDOWS_X64',
    xslt=>'$PG_PGBUILD_WINDOWS_X64',
    iconv=>'$PG_PGBUILD_GETTEXT_WINDOWS_X64',
    zlib=>'$PG_PGBUILD_WINDOWS_X64',        # --with-zlib=<path>
    icu=>'$PG_PGBUILD_WINDOWS_X64',        # --with-icu=<path>
    uuid=>'$PG_PGBUILD_WINDOWS_X64',       # --with-uuid-ossp
    lz4=>'$PG_PGBUILD_WINDOWS_X64'        # --with-lz4=<path>
};

1;
EOT

    cat <<EOT > "postgres.windows-x64/src/tools/msvc/buildenv.pl"
use strict;
use warnings;

\$ENV{VSINSTALLDIR} = '$PG_VSINSTALLDIR_WINDOWS_X64';
\$ENV{VCINSTALLDIR} = '$PG_VSINSTALLDIR_WINDOWS_X64\VC';
\$ENV{DevEnvDir} = '$PG_DEVENVDIR_WINDOWS_X64';
\$ENV{M4} = '$PG_PGBUILD_WINDOWS_X64\bin\m4.exe';
\$ENV{CONFIG} = 'Release $PLATFORM_TOOLSET';

\$ENV{PATH} = join
(
    ';' ,
    '$PG_MSBUILDDIR_WINDOWS_X64\bin',
    '$PG_DEVENVDIR_WINDOWS_X64',
    '$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Tools\MSVC\14.14.26428\bin\HostX64\x64',
    '$PG_PGBUILD_GETTEXT_WINDOWS_X64\bin',
    '$PG_PGBUILD_WINDOWS_X64\bin',
    '$PG_PERL_WINDOWS_X64\bin',
    '$PG_PYTHON_WINDOWS_X64',
    '$PG_TCL_WINDOWS_X64\bin',
    \$ENV{PATH}
);
         
\$ENV{INCLUDE} = join
(
    ';',
    '$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Tools\MSVC\14.14.26428\ATLMFC\INCLUDE',
    '$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Tools\MSVC\14.14.26428\INCLUDE',
    '$PG_PGBUILD_GETTEXT_WINDOWS_X64\include',
    '$PG_PGBUILD_WINDOWS_X64\include',
    \$ENV{INCLUDE}
);

\$ENV{LIB} = join
(
    ';',
    '$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Tools\MSVC\14.14.26428\ATLMFC\LIB',
    '$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Tools\MSVC\14.14.26428\LIB\onecore\x64',
    '$PG_PGBUILD_GETTEXT_WINDOWS_X64\lib',
    '$PG_PGBUILD_WINDOWS_X64\lib',
    \$ENV{LIB}
);

\$ENV{LIBPATH} = join
(
    ';',
    '$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Tools\MSVC\14.14.26428\ATLMFC\LIB'
);

1;
EOT

    # Create a config file for the debugger
    cat <<EOT > "postgres.windows-x64/contrib/pldebugger/settings.projinc"
<?xml version="1.0"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" DefaultTargets="all">

    <PropertyGroup>
    
        <!-- Debug build? -->
        <DEBUG>0</DEBUG>

        <!-- Compiler Architecture -->
        <ARCH>x64</ARCH>

        <!-- PostgreSQL source tree -->
        <PGPATH>..\..\</PGPATH>
        
        <!-- Gettext source tree -->
        <GETTEXTPATH>$PG_PGBUILD_WINDOWS_X64</GETTEXTPATH>
        
        <!-- OpenSSL source tree -->
        <OPENSSLPATH>$PG_PGBUILD_WINDOWS_X64</OPENSSLPATH>
        
    </PropertyGroup>
</Project>
EOT

    # create pgAdmin script and replace place holder
    if [ -f $WD/server/scripts/windows/build-pgadmin.bat ]; then
       rm -f $WD/server/scripts/windows/build-pgadmin.bat
    fi
    echo "CALL \"$PG_VSINSTALLDIR_WINDOWS_X64\Professional\VC\Auxiliary\Build\vcvarsall.bat\" amd64" > $WD/server/scripts/windows/build-pgadmin.bat
    cat $WD/server/scripts/windows/build-pgadmin.bat.in >> $WD/server/scripts/windows/build-pgadmin.bat
    _replace PGADMIN_SRC_DIR= "PGADMIN_SRC_DIR=${PG_PATH_WINDOWS_X64}\\\\pgadmin.windows-x64" $WD/server/scripts/windows/build-pgadmin.bat || _die "Failed to replace PGADMIN_SRC_DIR in build-pgadmin.bat"
    _replace PGADMIN_PYTHON_DIR= "PGADMIN_PYTHON_DIR=${PGADMIN_PYTHON_WINDOWS_X64}" $WD/server/scripts/windows/build-pgadmin.bat || _die "Failed to replace PGADMIN_PYTHON_WINDOWS_X64 in build-pgadmin.bat"
    _replace PGBUILD= "PGBUILD=${PG_PGBUILD_WINDOWS_X64}" $WD/server/scripts/windows/build-pgadmin.bat $WD/server/scripts/windows/build-pgadmin.bat || _die "Failed to replace PGBUILD in build-pgadmin.bat"
    _replace PGADMIN_KRB5_DIR= "PGADMIN_KRB5_DIR=${PGADMIN_KRB5_DIR}" $WD/server/scripts/windows/build-pgadmin.bat || _die "Failed to replace PGADMIN_KRB5_DIR in build-pgadmin.bat"
    _replace YARN_HOME= "YARN_HOME=${YARN_HOME}" $WD/server/scripts/windows/build-pgadmin.bat || _die "Failed to replace YARN_HOME in build-pgadmin.bat"
    _replace NODEJS_HOME= "NODEJS_HOME=${NODEJS_HOME}" $WD/server/scripts/windows/build-pgadmin.bat || _die "Failed to replace NODEJS_HOME in build-pgadmin.bat"

    # Zip up the scripts directories and copy them to the build host, then unzip
    cd $WD/server/scripts/windows/
    echo "Copying scripts source tree to Windows build VM"
    zip -r scripts.zip vc-build.bat build-pgadmin.bat vc-build-x64.bat vc-build-doc.bat vc-build-sys-stat.bat createuser getlocales validateuser || _die "Failed to pack the scripts source tree (ms-build.bat vc-build-x64.bat vc-build-x64.bat,vc-build-sys-stat.bat, createuser, getlocales, validateuser)"

    rsync -av scripts.zip $PG_SSH_WINDOWS_X64:$PG_CYGWIN_PATH_WINDOWS_X64 || _die "Failed to copy the scripts source tree to the windows-x64 build host (scripts.zip)"
    ssh -v $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; unzip -o scripts.zip" || _die "Failed to unpack the scripts source tree on the windows-x64 build host (scripts.zip)"
    
    # Build the code and install into a temporary directory
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\createuser; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat createuser.vcproj UPGRADE" || _die "Failed to build createuser on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\createuser; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat createuser.vcxproj Release $PLATFORM_TOOLSET" || _die "Failed to build createuser on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\getlocales; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat getlocales.vcproj UPGRADE" || _die "Failed to build getlocales on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\getlocales; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat getlocales.vcxproj Release $PLATFORM_TOOLSET" || _die "Failed to build getlocales on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\validateuser; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat validateuser.vcproj UPGRADE" || _die "Failed to build validateuser on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\validateuser; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat validateuser.vcxproj Release $PLATFORM_TOOLSET" || _die "Failed to build validateuser on the windows-x64 build host"
    
    # Move the resulting binaries into place
    ssh $PG_SSH_WINDOWS_X64 "cmd /c mkdir $PG_PATH_WINDOWS_X64\\\\output.build\\\\installer\\\\server" || _die "Failed to create the server directory on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PATH_WINDOWS_X64\\\\createuser\\\\x64\\\\release\\\\createuser.exe $PG_PATH_WINDOWS_X64\\\\output.build\\\\installer\\\\server" || _die "Failed to copy the createuser proglet on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PATH_WINDOWS_X64\\\\getlocales\\\\x64\\\\release\\\\getlocales.exe $PG_PATH_WINDOWS_X64\\\\output.build\\\\installer\\\\server" || _die "Failed to copy the getlocales proglet on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PATH_WINDOWS_X64\\\\validateuser\\\\x64\\\\release\\\\validateuser.exe $PG_PATH_WINDOWS_X64\\\\output.build\\\\installer\\\\server" || _die "Failed to copy the validateuser proglet on the windows-x64 build host"
    
    # Zip up the source directory and copy it to the build host, then unzip
    cd $WD/server/source/
    chmod +x postgres.windows-x64/src/tools/msvc/install.bat
    echo "Copying source tree to Windows build VM"
    rm postgres.windows-x64/contrib/pldebugger/Makefile # Remove the unix makefile so that the build scripts don't try to parse it - we have our own.
    zip -r postgres-win64.zip postgres.windows-x64 || _die "Failed to pack the source tree (postgres.windows-x64)"
    rsync -av postgres-win64.zip $PG_SSH_WINDOWS_X64:$PG_CYGWIN_PATH_WINDOWS_X64 || _die "Failed to copy the source tree to the windows-x64 build host (postgres-win64.zip)"
    ssh -v $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c unzip -o postgres-win64.zip" || _die "Failed to unpack the source tree on the windows-x64 build host (postgres-win64.zip)"
  
    PG_CYGWIN_PERL_WINDOWS_X64=`echo $PG_PERL_WINDOWS_X64 | sed -e 's;:;;g' | sed -e 's:\\\\:/:g' | sed -e 's:^:/cygdrive/:g'`
    PG_CYGWIN_PERL24_WINDOWS_X64=`echo $PG_PERL24_WINDOWS_X64 | sed -e 's;:;;g' | sed -e 's:\\\\:/:g' | sed -e 's:^:/cygdrive/:g'`
    PG_CYGWIN_PYTHON_WINDOWS_X64=`echo $PG_PYTHON_WINDOWS_X64 | sed -e 's;:;;g' | sed -e 's:\\\\:/:g' | sed -e 's:^:/cygdrive/:g'`
    PG_CYGWIN_TCL_WINDOWS_X64=`echo $PG_TCL_WINDOWS_X64 | sed -e 's;:;;g' | sed -e 's:\\\\:/:g' | sed -e 's:^:/cygdrive/:g'`
    PG_CYGWIN_PGBUILD_WINDOWS_X64=`echo $PG_PGBUILD_WINDOWS_X64 | sed -e 's;:;;g' | sed -e 's:\\\\:/:g' | sed -e 's:^:/cygdrive/:g'`


    # Build the code and install into a temporary directory
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64/postgres.windows-x64/src/tools/msvc; export PATH=\$PATH:$PG_CYGWIN_PERL24_WINDOWS_X64/bin:$PG_CYGWIN_PYTHON_WINDOWS_X64:$PG_CYGWIN_TCL_WINDOWS_X64/bin:$PG_CYGWIN_PGBUILD_WINDOWS_X64/bin; export M4=$PG_CYGWIN_PGBUILD_WINDOWS_X64/bin/m4.exe; export VisualStudioVersion=15.0; ./build.bat RELEASE" || _die "Failed to build postgres on the windows-x64 build host"

    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64/postgres.windows-x64/src/tools/msvc; export PATH=\$PATH:$PG_CYGWIN_PERL24_WINDOWS_X64/bin:$PG_CYGWIN_PYTHON_WINDOWS_X64:$PG_CYGWIN_TCL_WINDOWS_X64/bin; ./install.bat $PG_PATH_WINDOWS_X64\\\\output.build" || _die "Failed to install postgres on the windows-x64 build host"
    
    # Build the debugger plugins
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64/postgres.windows-x64/contrib/pldebugger; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat pldebugger.proj" || _die "Failed to build the pldebugger plugin"
    
    # Copy the debugger plugins into place
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PATH_WINDOWS_X64\\\\postgres.windows-x64\\\\contrib\\\\pldebugger\\\\plugin_debugger.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy the debugger plugin on the windows-x64 build host"

    # Copy the various support files into place
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\vcredist\\\\vcredist_x64.exe $PG_PATH_WINDOWS_X64\\\\output.build\\\\installer" || _die "Failed to copy the VC++ runtimes on the windows build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\vcredist\\\\vcredist_x86.exe $PG_PATH_WINDOWS_X64\\\\output.build\\\\installer" || _die "Failed to copy the VC++ runtimes on the windows build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\libssl-1_1-x64.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\libcrypto-1_1-x64.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_GETTEXT_WINDOWS_X64\\\\bin\\\\libiconv-2.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_GETTEXT_WINDOWS_X64\\\\bin\\\\libintl-9.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_GETTEXT_WINDOWS_X64\\\\bin\\\\libwinpthread-1.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\libxml2.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\libxslt.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\zlib1.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\libcurl.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\icu*.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\liblz4.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"

    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\lib\\\\liblz4.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\lib\\\\libssl.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\lib\\\\libcrypto.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_GETTEXT_WINDOWS_X64\\\\lib\\\\iconv.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_GETTEXT_WINDOWS_X64\\\\lib\\\\libintl.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\lib\\\\libxml2.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\lib\\\\libxslt.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\bin\\\\zlib.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\lib\\\\libcurl.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"

    # Copy the third party headers except GPL license headers 
    mkdir $WD/server/staging_cache/windows-x64/3rdinclude/
    scp $PG_SSH_WINDOWS_X64:$PG_PGBUILD_WINDOWS_X64/include/*.h  $WD/server/staging_cache/windows-x64/3rdinclude/ || _die "Failed to copy the third party headers to $WD/server/staging_cache/windows-x64/3rdinclude/ )"
    find $WD/server/staging_cache/windows-x64/3rdinclude/ -name "*.h" -exec grep -rwl "GNU General Public License" {} \; -exec rm  {} \; || _die "Failed to remove the GPL license header files."
    scp -r $WD/server/staging_cache/windows-x64/3rdinclude/* $PG_SSH_WINDOWS_X64:$PG_PATH_WINDOWS_X64\\\\output.build\\\\include || _die "Failed to copy the third party headers to ($PG_SSH_WINDOWS_X64:$PG_PATH_WINDOWS_X64/output.build/include)"
    rm -rf $WD/server/staging_cache/windows-x64/3rdinclude || _die "Failed to remove the third party headers directory"

    ssh $PG_SSH_WINDOWS_X64 "cmd /c mkdir \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\include\\\\openssl\"" || _die "Failed to create openssl directory"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\include\\\\openssl\\\\*.h $PG_PATH_WINDOWS_X64\\\\output.build\\\\include\\\\openssl" || _die "Failed to copy third party headers on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c mkdir \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\include\\\\libxml\"" || _die "Failed to create libxml directory"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\include\\\\libxml\\\\*.h $PG_PATH_WINDOWS_X64\\\\output.build\\\\include\\\\libxml" || _die "Failed to copy third party headers on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c mkdir \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\include\\\\libxslt\"" || _die "Failed to create libxslt directory"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\include\\\\libxslt\\\\*.h $PG_PATH_WINDOWS_X64\\\\output.build\\\\include\\\\libxslt" || _die "Failed to copy third party headers on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\include\\\\lz4*.h $PG_PATH_WINDOWS_X64\\\\output.build\\\\include" || _die "Failed to copy third party headers on the windows-x64 build host"

    ssh $PG_SSH_WINDOWS_X64 "cmd /c mkdir \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\include\\\\unicode\"" || _die "Failed to create unicode directory"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_WINDOWS_X64\\\\include\\\\unicode\\\\*.h $PG_PATH_WINDOWS_X64\\\\output.build\\\\include\\\\unicode" || _die "Failed to copy third party headers on the windows-x64 build host"

    # Copy the wxWidgets libraries
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxbase313ud_net_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxbase313u_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxbase313u_xml_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw313u_adv_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw313ud_aui_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw313u_core_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw313ud_html_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    #ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw313ud_stc_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw313ud_xrc_vc_x64_custom.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to copy a dependency DLL on the windows-x64 build host"

    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxbase31ud_net.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxbase31ud.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxbase31ud_xml.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw31ud_adv.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw31ud_aui.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw31ud_core.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw31ud_html.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    #ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw31ud_stc.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw31ud_xrc.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_WXWIN_WINDOWS_X64\\\\lib\\\\vc_x64_dll\\\\wxmsw31u_adv.lib $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy a dependency lib on the windows-x64 build host"
    #####################
    # pgAdmin
    #####################
    echo "Copying pgAdmin source tree to Windows build VM"
    zip -r pgadmin-win64.zip pgadmin.windows-x64 || _die "Failed to pack the source tree (pgadmin.windows-x64)"
    rsync -av pgadmin-win64.zip $PG_SSH_WINDOWS_X64:$PG_CYGWIN_PATH_WINDOWS_X64 || _die "Failed to copy the source tree to the windows-x64 build host (pgadmin-win64.zip)"
    ssh -v $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c unzip -o pgadmin-win64.zip" || _die "Failed to unpack the source tree on the windows-x64 build host (pgadmin-win64.zip)"


    #Create pgAdmin4 folder inside the output.build
    ssh $PG_SSH_WINDOWS_X64 "mkdir \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\pgAdmin 4\"" || _die "Failed to create a pgAdmin 4 directory on the windows build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64/pgadmin.windows-x64; cmd /c $PG_PATH_WINDOWS_X64\\\\build-pgadmin.bat" || _die "Failed to build pgadmin"
    ssh $PG_SSH_WINDOWS_X64 "cp -R $PG_PATH_WINDOWS_X64\\\\pgadmin.windows-x64\\\\win-build\\\\docs \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\pgAdmin 4\\\\docs\"" || _die "Failed to copy pgAdmin doc"
    ssh $PG_SSH_WINDOWS_X64 "cp -R $PG_PATH_WINDOWS_X64\\\\pgadmin.windows-x64\\\\win-build\\\\python \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\pgAdmin 4\\\\python\"" || _die "Failed to copy pgAdmin python"
    ssh $PG_SSH_WINDOWS_X64 "cp -R $PG_PATH_WINDOWS_X64\\\\pgadmin.windows-x64\\\\win-build\\\\runtime \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\pgAdmin 4\\\\bin\"" || _die "Failed to copy pgAdmin bin"
    ssh $PG_SSH_WINDOWS_X64 "cp -R $PG_PATH_WINDOWS_X64\\\\pgadmin.windows-x64\\\\win-build\\\\web \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\pgAdmin 4\\\\web\"" || _die "Failed to copy pgAdmin web"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_GETTEXT_WINDOWS_X64\\\\bin\\\\libiconv-2.dll \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\pgAdmin 4\\\\bin\"" || _die "Failed to copy libiconv-2.dll"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PGBUILD_GETTEXT_WINDOWS_X64\\\\bin\\\\libintl-9.dll \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\pgAdmin 4\\\\bin\"" || _die "Failed to copy libintl-9.dll"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c copy $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin\\\\libpq.dll \"$PG_PATH_WINDOWS_X64\\\\output.build\\\\pgAdmin 4\\\\bin\"" || _die "Failed to copy libpq.dll"


    ##################################
    # Build the system_stats extension
    ##################################
    cd $WD/server/source/
    echo "Copying StackBuilder source tree to Windows build VM"
    zip -r system_stats-win64.zip system_stats.windows-x64 || _die "Failed to pack the source tree (system_stats.windows-x64)"
    rsync -av system_stats-win64.zip $PG_SSH_WINDOWS_X64:$PG_CYGWIN_PATH_WINDOWS_X64 || _die "Failed to copy the source tree to the windows-x64 build host (system_stats-win64.zip)"
    ssh -v $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c unzip -o system_stats-win64.zip" || _die "Failed to unpack the source tree on the windows-x64 build host (system_stats-win64.zip)"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\system_stats.windows-x64; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-sys-stat.bat system_stats.vcxproj Release $PLATFORM_TOOLSET" || _die "Failed to build system_stats on the build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\system_stats.windows-x64; cmd /c copy system_stats--*.sql $PG_PATH_WINDOWS_X64\\\\output.build\\\\share\\\\extension" || _die "Failed to copy system_stats--*.sql in output.build/share/extension"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\system_stats.windows-x64; cmd /c copy system_stats.control $PG_PATH_WINDOWS_X64\\\\output.build\\\\share\\\\extension" || _die "Failed to copy system_stats.control in output.build/share/extension"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\system_stats.windows-x64\\\\x64\\\\Release; cmd /c copy system_stats.dll $PG_PATH_WINDOWS_X64\\\\output.build\\\\lib" || _die "Failed to copy system_stats.dll output.build/lib"
    
    #####################
    # StackBuilder
    #####################
    cd $WD/server/source/
    echo "Copying StackBuilder source tree to Windows build VM"
    zip -r stackbuilder-win64.zip stackbuilder.windows-x64 || _die "Failed to pack the source tree (stackbuilder.windows-x64)"
    rsync -av stackbuilder-win64.zip $PG_SSH_WINDOWS_X64:$PG_CYGWIN_PATH_WINDOWS_X64 || _die "Failed to copy the source tree to the windows-x64 build host (stackbuilder-win64.zip)"
    ssh -v $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c unzip -o stackbuilder-win64.zip" || _die "Failed to unpack the source tree on the windows-x64 build host (stackbuilder-win64.zip)"

    # Build the code
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64/stackbuilder.windows-x64; cmd /c $PG_CMAKE_WINDOWS_X64/bin/cmake -G \"$CMAKE_BUILD_GENERATOR_WINDOWS_X64 Win64\" -D MS_VS_10=1 -D CURL_ROOT:PATH=$PG_PGBUILD_WINDOWS_X64 -D WX_ROOT_DIR=$PG_WXWIN_WINDOWS_X64 -D WX_VERSION="3.1" -D WX_STATIC=NO -D MSGFMT_EXECUTABLE=$PG_PGBUILD_WINDOWS_X64\\\\bin\\\\msgfmt -D CMAKE_INSTALL_PREFIX=$PG_PATH_WINDOWS_X64\\\\output.build\\\\StackBuilder -D CMAKE_CXX_FLAGS=\"/D _UNICODE /EHsc\" ." || _die "Failed to configure stackbuilder on the build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64/stackbuilder.windows-x64; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat stackbuilder.vcxproj Release $PLATFORM_TOOLSET" || _die "Failed to build stackbuilder on the build host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64/stackbuilder.windows-x64; cmd /c $PG_PATH_WINDOWS_X64\\\\vc-build-x64.bat INSTALL.vcxproj Release $PLATFORM_TOOLSET" || _die "Failed to install stackbuilder on the build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c mv $PG_PATH_WINDOWS_X64\\\\output.build\\\\StackBuilder\\\\bin\\\\stackbuilder.exe $PG_PATH_WINDOWS_X64\\\\output.build\\\\bin" || _die "Failed to relocate the stackbuilder executable on the build host"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c rd $PG_PATH_WINDOWS_X64\\\\output.build\\\\StackBuilder\\\\bin" || _die "Failed to remove the stackbuilder bin directory on the build host"

    echo "Removing last successful staging directory ($PG_PATH_WINDOWS_X64\\\\output)"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; rm -rf output" || _die "Couldn't remove the last successful staging directory directory"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c mkdir $PG_PATH_WINDOWS_X64\\\\output" || _die "Couldn't create the last successful staging directory"

    echo "Copying the complete build to the successful staging directory"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cp -r output.build/* output" || _die "Couldn't copy the existing staging directory"

    ssh $PG_SSH_WINDOWS_X64 "cmd /c echo PG_MAJOR_VERSION=$PG_MAJOR_VERSION > $PG_PATH_WINDOWS_X64\\\\output/versions-windows-x64.sh" || _die "Failed to write server version number into versions-windows-x64.sh"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c echo PG_MINOR_VERSION=$PG_MINOR_VERSION >> $PG_PATH_WINDOWS_X64\\\\output/versions-windows-x64.sh" || _die "Failed to write server build number into versions-windows-x64.sh"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c echo PG_PACKAGE_VERSION=$PG_PACKAGE_VERSION >> $PG_PATH_WINDOWS_X64\\\\output/versions-windows-x64.sh" || _die "Failed to write server build number into versions-windows-x64.sh"
    
   cd $WD
   echo "END BUILD Server Windows-x64"
}


################################################################################
# Post process
################################################################################

_postprocess_server_windows_x64() {
    echo "BEGIN POST Server Windows-x64"

    # Remove any existing staging directory that might exist, and create a clean one
    if [ -e $WD/server/staging/windows-x64 ];
    then
        echo "Removing existing staging directory"
        rm -rf $WD/server/staging/windows-x64 || _die "Couldn't remove the existing staging directory"
    fi
    echo "Creating staging directory ($WD/server/staging/windows-x64)"
    mkdir -p $WD/server/staging/windows-x64 || _die "Couldn't create the staging directory"

    # Zip up the installed code, copy it back here, and unpack.
    echo "Copying built tree to Unix host"
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c if EXIST output.zip del /S /Q output.zip" || _die "Couldn't remove the $PG_PATH_WINDOWS_X64\\output.zip on Windows VM"
    ssh -v $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64\\\\output; zip -r ..\\\\output.zip *" || _die "Failed to pack the built source tree ($PG_SSH_WINDOWS_X64:$PG_PATH_WINDOWS_X64/output)"
    rsync -av $PG_SSH_WINDOWS_X64:$PG_CYGWIN_PATH_WINDOWS_X64/output.zip $WD/server/staging_cache/windows-x64 || _die "Failed to copy the built source tree ($PG_SSH_WINDOWS_X64:$PG_PATH_WINDOWS_X64/output.zip)"
    unzip -o $WD/server/staging_cache/windows-x64/output.zip -d $WD/server/staging_cache/windows-x64/ || _die "Failed to unpack the built source tree ($WD/staging_cache/windows-x64/output.zip)"
    rm $WD/server/staging_cache/windows-x64/output.zip

    dos2unix $WD/server/staging_cache/windows-x64/versions-windows-x64.sh || _die "Failed to convert format of versions-windows-x64.sh from dos to unix"
    source $WD/server/staging_cache/windows-x64/versions-windows-x64.sh
    PG_BUILD_SERVER=$(expr $PG_BUILD_SERVER + $SKIPBUILD)

    # fixes #35408. In 9.5, some modules were moved from contrib to src/test/modules. They are meant for server testing
    # and should not be packaged for distribution. On Unix, the top level make does not build these, but on windows it does.
    # Hence, removing the files of these modules from the staging_cache
    find $WD/server/staging_cache/windows-x64/ -type f \( -name "test_parser*" -o -name "test_shm_mq*" -o -name "test_ddl_deparse*" \
                                               -o -name "test_rls_hooks*" -o -name "worker_spi*" -o -name "dummy_seclabel*" \) -exec rm {} \;

	win32_sign "stackbuilder.exe" "$WD/server/staging_cache/windows-x64/bin"
    
    # Install the PostgreSQL docs
    mkdir -p $WD/server/staging_cache/windows-x64/doc/postgresql/html || _die "Failed to create the doc directory"
    cd $WD/server/staging_cache/windows-x64/doc/postgresql/html || _die "Failed to change to the doc directory"
    cp -R $WD/server/source/postgres.windows-x64/doc/src/sgml/html/* . || _die "Failed to copy the PostgreSQL documentation"
    
    # Copy in the plDebugger docs & SQL script
    cp $WD/server/source/postgresql-$PG_TARBALL_POSTGRESQL/contrib/pldebugger/README.pldebugger $WD/server/staging_cache/windows-x64/doc
    cp $WD/server/source/postgresql-$PG_TARBALL_POSTGRESQL/contrib/pldebugger/pldbgapi*.sql $WD/server/staging_cache/windows-x64/share/extension
    cp $WD/server/source/postgresql-$PG_TARBALL_POSTGRESQL/contrib/pldebugger/pldbgapi.control $WD/server/staging_cache/windows-x64/share/extension

   cd $WD/server
   # Copy debug symbols to output/symbols directory
   if [ -e "$WD/output/symbols/windows-x64/server" ];
   then
       echo "Removing the exsisting symbol directory"
       rm -rf $WD/output/symbols/windows-x64/server || _die "Failed to clean the symbols directory"
   fi
   mkdir -p $WD/output/symbols/windows-x64/server || _die "Failed to create $WD/output/symbols/windows-x64 directory"
   cp -r staging_cache/windows-x64/symbols/* $WD/output/symbols/windows-x64/server || _die "Failed to copy symbols to $WD/output/symbols/windows-x64/server directory"

   #Restructuring staging
   echo "Restructuring staging as per components"
   mkdir -p $PGSERVER_STAGING_WINDOWS_X64 || _die "Couldn't create the staging directory $PGSERVER_STAGING_WINDOWS_X64"
   mkdir -p $PGADMIN_STAGING_WINDOWS_X64 || _die "Couldn't create the staging directory $PGADMIN_STAGING_WINDOWS_X64"
   mkdir -p $SB_STAGING_WINDOWS_X64 || _die "Couldn't create the staging directory $SB_STAGING_WINDOWS_X64"
   mkdir -p $CLT_STAGING_WINDOWS_X64 || _die "Couldn't create the staging directory $CLT_STAGING_WINDOWS_X64"
   chmod ugo+w $PGSERVER_STAGING_WINDOWS_X64 $PGADMIN_STAGING_WINDOWS_X64 $SB_STAGING_WINDOWS_X64 $CLT_STAGING_WINDOWS_X64 || _die "Couldn't set the permissions on the staging directory"

   echo "Restructuring Server"
   cp -r $WD/server/staging_cache/windows-x64/include $PGSERVER_STAGING_WINDOWS_X64 || _die "Failed to copy include"
   cp -r $WD/server/staging_cache/windows-x64/share   $PGSERVER_STAGING_WINDOWS_X64 || _die "Failed to copy share"
   cp -r $WD/server/staging_cache/windows-x64/bin   $PGSERVER_STAGING_WINDOWS_X64 || _die "Failed to copy bin"
   cp -r $WD/server/staging_cache/windows-x64/installer   $PGSERVER_STAGING_WINDOWS_X64 || _die "Failed to copy installer"
   cp -r $WD/server/staging_cache/windows-x64/installer   $CLT_STAGING_WINDOWS_X64 || _die "Failed to copy installer"

   echo "Restructuring commandlinetools"
   mkdir -p $CLT_STAGING_WINDOWS_X64/bin || _die "Couldn't create the staging directory $CLT_STAGING_WINDOWS_X64/bin"
   cp -r $WD/server/staging_cache/windows-x64/lib   $CLT_STAGING_WINDOWS_X64 || _die "Failed to move lib"

   mv $PGSERVER_STAGING_WINDOWS_X64/bin/zlib1.dll $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move zlib1.dll"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/libwinpthread-1.dll $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move libwinpthread-1.dll"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/psql.exe $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move psql.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/libpq*   $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move bin/libpq"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/pg_basebackup.exe  $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move pg_basebackup"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/pg_dump* $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move pg_dump and pg_dumpall"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/pg_restore.exe $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move pg_restore.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/createdb.exe   $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move createdb.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/clusterdb.exe  $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move clusterdb.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/createuser.exe $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move createuser"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/dropdb.exe     $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move dropdb.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/dropuser.exe  $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move dropuser.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/pg_isready.exe $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move pg_isready.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/vacuumdb.exe     $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move vacuumdb.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/reindexdb.exe     $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move reindexdb.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/pgbench.exe     $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move pgbench.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/vacuumlo.exe     $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move vacuumlo.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/liblz4.dll $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move liblz4.dll"
   mkdir -p $CLT_STAGING_WINDOWS_X64/scripts/images || _die "Couldn't create the staging directory $CLT_STAGING_WINDOWS_X64/scripts/images"
   cp $WD/server/resources/pg-psql.ico  $CLT_STAGING_WINDOWS_X64/scripts/images/ || _die "Failed to move scripts/images/pg-psql.ico"
   cp $WD/server/scripts/windows/runpsql.bat  $CLT_STAGING_WINDOWS_X64/scripts/ || _die "Failed to move runpsql.bat"

   echo "Restructuring pgAdmin4"
   cp -r $WD/server/staging_cache/windows-x64/pgAdmin\ 4/  $PGADMIN_STAGING_WINDOWS_X64 || _die "Failed to copy pgAdmin\ 4/ directory to staging directory $PGADMIN_STAGING_WINDOWS_X64"

   echo "Restructuring Stackbuilder"
   mkdir -p $SB_STAGING_WINDOWS_X64/bin || _die "Couldn't create the staging directory $CLT_STAGING_WINDOWS/scripts/images"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/stackbuilder.exe $SB_STAGING_WINDOWS_X64/bin || _die "Failed to move stackbuilder.exe"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/wx*.dll $SB_STAGING_WINDOWS_X64/bin || _die "Failed to move wx*dlls"
   mv $PGSERVER_STAGING_WINDOWS_X64/bin/libcurl.dll $SB_STAGING_WINDOWS_X64/bin || _die "Failed to move libcurl.dll"
   cp -r $WD/server/staging_cache/windows-x64/StackBuilder/share $SB_STAGING_WINDOWS_X64/ ||  _die "Failed to copy $WD/server/staging_cache/windows-x64/stackbuilder/share"
   cp $PGSERVER_STAGING_WINDOWS_X64/bin/libssl-1_1-x64.dll $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move libssl-1_1-x64.dll"
   cp $PGSERVER_STAGING_WINDOWS_X64/bin/libcrypto-1_1-x64.dll $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move libcrypto-1_1-x64.dll"
   cp $PGSERVER_STAGING_WINDOWS_X64/bin/libiconv-2.dll $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move libiconv-2.dll"
   cp $PGSERVER_STAGING_WINDOWS_X64/bin/libintl-9.dll $CLT_STAGING_WINDOWS_X64/bin || _die "Failed to move libintl-9.dll"


    cd $WD/server

    #generate commandlinetools license file
    pushd $CLT_STAGING_WINDOWS_X64
        generate_3rd_party_license "commandlinetools"
    popd

    #generate pgAdmin4 license file
    pushd $PGADMIN_STAGING_WINDOWS_X64
        generate_3rd_party_license "pgAdmin"
    popd

    #generate StackBuilder license file
    pushd $SB_STAGING_WINDOWS_X64
        generate_3rd_party_license "StackBuilder"
    popd

    # Welcome doc
    cp "$WD/server/resources/installation-notes.html" "$WD/server/staging_cache/windows-x64/doc/" || _die "Failed to install the welcome document"
    cp "$WD/server/resources/edblogo.png" "$WD/server/staging_cache/windows-x64/doc/" || _die "Failed to install the welcome logo"

    #Creating a archive of the binaries
    mkdir -p $WD/server/staging_cache/windows-x64/pgsql || _die "Failed to create the directory for binaries "
    cd $WD/server/staging_cache/windows-x64
    cp -R bin doc include lib pgAdmin* share StackBuilder symbols pgsql/ || _die "Failed to copy the binaries to the pgsql directory"

    zip -rq postgresql-$PG_PACKAGE_VERSION-windows-x64-binaries.zip pgsql || _die "Failed to archive the postgresql binaries"
    mv postgresql-$PG_PACKAGE_VERSION-windows-x64-binaries.zip $WD/output/ || _die "Failed to move the archive to output folder"

    rm -rf pgsql || _die "Failed to remove the binaries directory" 

    #Updating the docs in restructured staging
    cp -r $WD/server/staging_cache/windows-x64/doc $PGSERVER_STAGING_WINDOWS_X64 || _die "Failed to copy documentation"
    cp $WD/resources/license.txt $PGSERVER_STAGING_WINDOWS_X64/server_license.txt
    cp $WD/server/source/pgadmin.windows-x64/LICENSE $PGADMIN_STAGING_WINDOWS_X64/pgAdmin_license.txt


    #Copy the symbols to staging directory
    mkdir -p $PGSERVER_STAGING_WINDOWS_X64/debug_symbols
    cp -r $WD/output/symbols/windows-x64/server/* $PGSERVER_STAGING_WINDOWS_X64/debug_symbols

    cd $WD/server

    # Setup the installer scripts. 
    mkdir -p $PGSERVER_STAGING_WINDOWS_X64/installer/server || _die "Failed to create a directory for the install scripts"
    cp scripts/windows/prerun_checks.vbs $PGSERVER_STAGING_WINDOWS_X64/installer/prerun_checks.vbs || _die "Failed to copy the prerun_checks.vbs script ($WD/scripts/windows-x64/prerun_checks.vbs)"
    cp scripts/windows/initcluster.vbs $PGSERVER_STAGING_WINDOWS_X64/installer/server/initcluster.vbs || _die "Failed to copy the loadmodules script (scripts/windows/initcluster.vbs)"
    cp scripts/windows/startupcfg.vbs $PGSERVER_STAGING_WINDOWS_X64/installer/server/startupcfg.vbs || _die "Failed to copy the startupcfg script (scripts/windows/startupcfg.vbs)"
    cp scripts/windows/createshortcuts_server.vbs $PGSERVER_STAGING_WINDOWS_X64/installer/server/createshortcuts_server.vbs || _die "Failed to copy the createshortcuts script (scripts/windows/createshortcuts_server.vbs)"
    cp scripts/windows/createshortcuts_clt.vbs $CLT_STAGING_WINDOWS_X64/installer/server/createshortcuts_clt.vbs || _die "Failed to copy the createshortcuts script (scripts/windows/createshortcuts_clt.vbs)"
    cp scripts/windows/startserver.vbs $PGSERVER_STAGING_WINDOWS_X64/installer/server/startserver.vbs || _die "Failed to copy the startserver script (scripts/windows/startserver.vbs)"
    cp scripts/windows/loadmodules.vbs $PGSERVER_STAGING_WINDOWS_X64/installer/server/loadmodules.vbs || _die "Failed to copy the loadmodules script (scripts/windows/loadmodules.vbs)"
    
    # Copy in the menu pick images and XDG items
    mkdir -p $PGSERVER_STAGING_WINDOWS_X64/scripts/images || _die "Failed to create a directory for the menu pick images"
    cp resources/pg-help.ico $PGSERVER_STAGING_WINDOWS_X64/scripts/images || _die "Failed to copy the menu pick images (resources/pg-help.ico)"
    cp resources/pg-reload.ico $PGSERVER_STAGING_WINDOWS_X64/scripts/images || _die "Failed to copy the menu pick images (resources/pg-reload.ico)"

   # Copy in the menu pick images and XDG items
    mkdir -p $PGADMIN_STAGING_WINDOWS_X64/scripts/images || _die "Failed to create a directory for the menu pick images"
    cp resources/pg-help.ico $PGADMIN_STAGING_WINDOWS_X64/scripts/images/pgadmin-help.ico || _die "Failed to copy the menu pick images (resources/pg-help.ico)"
    cp $WD/server/source/pgadmin.windows-x64/pkg/win32/Resources/pgAdmin4.ico $PGADMIN_STAGING_WINDOWS_X64/scripts/images/ || _die "Failed to copy the pgAdmin4.ico file"

    # Copy the launch scripts
    cp scripts/windows/serverctl.vbs $PGSERVER_STAGING_WINDOWS_X64/scripts/serverctl.vbs || _die "Failed to copy the serverctl script (scripts/windows/serverctl.vbs)"
    cp scripts/windows/runpsql.bat $PGSERVER_STAGING_WINDOWS_X64/scripts/runpsql.bat || _die "Failed to copy the runpsql script (scripts/windows/runpsql.bat)"
    # Prepare the installer XML file
    _prepare_server_xml "windows-x64"

    # Build the installer
    "$PG_INSTALLBUILDER_BIN" build installer-windows-x64.xml windows || _die "Failed to build the installer"

    # If build passed empty this variable
    BUILD_FAILED="build_failed-"
    if [ $PG_BUILD_SERVER -gt 0 ];
    then
        BUILD_FAILED=""
    fi

    # Rename the installer
    mv $WD/output/postgresql-$PG_MAJOR_VERSION-windows-installer.exe $WD/output/postgresql-$PG_PACKAGE_VERSION-${BUILD_FAILED}windows-x64.exe || _die "Failed to rename the installer"

    # Sign the installer
    win32_sign "postgresql-$PG_PACKAGE_VERSION-${BUILD_FAILED}windows-x64.exe"

    # Copy installer onto the build system
    ssh $PG_SSH_WINDOWS_X64 "cd $PG_PATH_WINDOWS_X64; cmd /c rd /S /Q component_installers"
    ssh $PG_SSH_WINDOWS_X64 "cmd /c mkdir $PG_PATH_WINDOWS_X64\\\\component_installers" || _die "Failed to create the component_installers directory on the windows-x64 build host"
    rsync -av $WD/output/postgresql-$PG_PACKAGE_VERSION-${BUILD_FAILED}windows-x64.exe $PG_SSH_WINDOWS_X64:$PG_CYGWIN_PATH_WINDOWS_X64/component_installers || _die "Unable to copy installers at windows-x64 build machine."
    
    cd $WD
    echo "END POST Server Windows-x64"
}

