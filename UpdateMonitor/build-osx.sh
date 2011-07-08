#!/bin/bash

################################################################################
# Build preparation UpdateMonitor
################################################################################

_prep_updatemonitor_osx() {

    echo "**************************************"
    echo "* Preparing - UpdateMonitor (osx) *"
    echo "**************************************"

    # Enter the source directory and cleanup if required
    cd $WD/UpdateMonitor/source

    if [ -e updatemonitor.osx ];
    then
      echo "Removing existing updatemonitor.osx source directory"
      rm -rf updatemonitor.osx  || _die "Couldn't remove the existing updatemonitor.osx source directory (source/updatemonitor.osx)"
    fi
   
    echo "Creating source directory ($WD/UpdateMonitor/source/updatemonitor.osx)"
    mkdir -p $WD/UpdateMonitor/source/updatemonitor.osx || _die "Couldn't create the updatemonitor.osx directory"

    # Grab a copy of the source tree
    cp -R SS-UPDATEMANAGER/* updatemonitor.osx || _die "Failed to copy the source code (source/SS-UPDATEMANAGER)"
    chmod -R ugo+w updatemonitor.osx || _die "Couldn't set the permissions on the source directory (SS-UPDATEMANAGER)"

    # Remove any existing staging directory that might exist, and create a clean one
    if [ -e $WD/UpdateMonitor/staging/osx ];
    then
      echo "Removing existing staging directory"
      rm -rf $WD/UpdateMonitor/staging/osx || _die "Couldn't remove the existing staging directory"
    fi

    echo "Creating staging directory ($WD/UpdateMonitor/staging/osx)"
    mkdir -p $WD/UpdateMonitor/staging/osx || _die "Couldn't create the staging directory"
    chmod ugo+w $WD/UpdateMonitor/staging/osx || _die "Couldn't set the permissions on the staging directory"

}

################################################################################
# UpdateMonitor Build
################################################################################

_build_updatemonitor_osx() {

    echo "*************************************"
    echo "* Building - UpdateMonitor (osx) *"
    echo "*************************************"

    cd $WD/UpdateMonitor/source/updatemonitor.osx

    # Append mac specific setting in the UpdateMonitor Project
    cat <<EOT > /tmp/UpdateMonitor.pro

mac {
    QMAKE_MAC_SDK=$PG_OSX_SDK
    CONFIG+=x86 ppc
    QMAKE_MACOSX_DEPLOYMENT_TARGET=$PG_OSX_DEPLOYMENT_TARGET
}

EOT
    cat /tmp/UpdateMonitor.pro >> UpdateMonitor.pro
    qmake UpdateMonitor.pro
    xcodebuild -configuration Release

    if [ ! -d UpdateManager.app ]; then
        _die "Failed building UpdateManager"
    fi

    cd UpdateManager.app/Contents/MacOS

    echo "Copying dependent library QtCore"
    cp -R /Library/Frameworks/QtCore.framework QtCore.framework
    echo "Copying dependent library QtGui"
    cp -R /Library/Frameworks/QtGui.framework  QtGui.framework
    echo "Copying dependent library QtNetwork"
    cp -R /Library/Frameworks/QtNetwork.framework  QtNetwork.framework
    echo "Copying dependent library QtXml"
    cp -R /Library/Frameworks/QtXml.framework  QtXml.framework

    # Remove unnecessary files i.e. Headers & debug from the Qt
    QT_HEADERS_FILES=`find . | grep Headers`
    for f in $QT_HEADERS_FILES
    do
        rm -rf $f
    done
    QT_DEBUG_FILES=`find . | grep "_debug"`
    for f in $QT_DEBUG_FILES
    do
        rm -rf $f
    done

    #Copy our custom Info.plist
    cp $WD/UpdateMonitor/source/updatemonitor.osx/Info.plist $WD/UpdateMonitor/source/updatemonitor.osx/updatemonitor.app/Contents/Info.plist || _die "Failed to change the Info.plist"     

    cd $WD/UpdateMonitor/source
    echo "Copy the UpdateManager app bundle into place"
    cp -R $WD/UpdateMonitor/source/updatemonitor.osx/UpdateManager.app $WD/UpdateMonitor/staging/osx/UpdateManager.app || _die "Failed to copy UpdateMonitor into the staging directory"

    cd $WD
}


################################################################################
# UpdateMonitor PostProcess
################################################################################

_postprocess_updatemonitor_osx() {

    echo "********************************************"
    echo "* Post-processing - UpdateMonitor (osx) *"
    echo "********************************************"

    cd $WD/UpdateMonitor

    mkdir -p staging/osx/installer/UpdateMonitor || _die "Failed to create a directory for the install scripts"
    mkdir -p staging/osx/UpdateMonitor/installer/UpdateMonitor || _die "Failed to create a directory for the install scripts"

    mkdir -p staging/osx/UpdateMonitor/scripts || _die "Failed to create a directory for the launch scripts"
    cp scripts/osx/launchUpdateMonitor.sh staging/osx/UpdateMonitor/scripts/launchUpdateMonitor.sh || _die "Failed to copy the launch script (scripts/osx/launchSBPUpdateMonitor.sh)"
    cp scripts/osx/launchupdatemonitor.applescript.in staging/osx/UpdateMonitor/scripts/launchupdatemonitor.applescript || _die "Failed to copy the launch script (scripts/osx/launchupdatemonitor.applescript.in)"
    cp scripts/osx/startupcfg.sh staging/osx/UpdateMonitor/installer/UpdateMonitor/startupcfg.sh || _die "Failed to copy the startupcfg script (scripts/osx/startupcfg.sh)"
    chmod ugo+x staging/osx/scripts/*.sh

    # Copy in the menu pick images and XDG items
    mkdir -p staging/osx/scripts/images || _die "Failed to create a directory for the menu pick images"

    if [ -f installer_1.xml ]; then
        rm -f installer_1.xml
    fi

    if [ ! -f $WD/scripts/risePrivileges ]; then
        cp installer.xml installer_1.xml
        _replace "<requireInstallationByRootUser>\${admin_rights}</requireInstallationByRootUser>" "<requireInstallationByRootUser>1</requireInstallationByRootUser>"

        # Build the installer (for the root privileges required)
        echo Building the installer with the root privileges required
        "$PG_INSTALLBUILDER_BIN" build installer_1.xml osx || _die "Failed to build the installer"
        cp $WD/output/updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app/Contents/MacOS/psqlODBC $WD/scripts/risePrivileges || _die "Failed to copy privileges escalation applet"
        rm -rf $WD/output/updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app
    fi
    
    # Build the installer
    "$PG_INSTALLBUILDER_BIN" build installer.xml osx || _die "Failed to build the installer (UpdateMonitor)"

    # Using own scripts for extract-only mode
    cp -f $WD/scripts/risePrivileges $WD/output/updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app/Contents/MacOS/UpdateMonitor
    chmod a+x $WD/output/updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app/Contents/MacOS/UpdateMonitor
    cp -f $WD/resources/extract_installbuilder.osx $WD/output/updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app/Contents/MacOS/installbuilder.sh
    _replace @@PROJECTNAME@@ UpdateMonitor $WD/output/updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app/Contents/MacOS/installbuilder.sh
    chmod a+x $WD/output/updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app/Contents/MacOS/installbuilder.sh

    # Zip up the output
    cd $WD/output
    zip -r updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.zip updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app/ || _die "Failed to zip the installer bundle"
    rm -rf updatemonitor-$PG_VERSION_UPDATE_MONITOR-$PG_BUILDNUM_UPDATE_MONITOR-osx.app/ || _die "Failed to remove the unpacked installer bundle"
    
}

