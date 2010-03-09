#!/bin/sh

# Postgres Plus HQ Agent shortcut creation script for Linux
# Ashesh Vashi, EnterpriseDB

# Check the command line
if [ $# -ne 5 ];
then
    echo "Usage: $0 <Product Version> <Branding> <Install dir> <java_home> <serviceuser>"
    exit 127
fi

VERSION=$1
BRANDING=$2
INSTALLDIR=$3
JAVAHOME=$4
SERVICEUSER=$5

# Exit code
WARN=0

BRANDING_STR=`echo $BRANDING | sed 's/\./_/g' | sed 's/ /_/g'`

# Error handlers
_die() {
    echo $1
    exit 1
}

_warn() {
    echo $1
    WARN=2
}

# Search & replace in a file - _replace($find, $replace, $file)
_replace() {
    sed -e "s^$1^$2^g" $3 > "/tmp/$$.tmp" || return 1
    mv /tmp/$$.tmp $3 || return 1
}

# Fixup the scripts
_fixup_file() {
  _replace @@PPHQVERSION@@      "$VERSION"       $1
  _replace @@INSTALLDIR@@       "$INSTALLDIR"    $1
  _replace @@BRANDING@@         "$BRANDING"      $1
  _replace @@JAVAHOME@@         "$JAVAHOME"      $1
  _replace @@AGENTSERVICEUSER@@ "${SERVICEUSER}" $1
}

_fixup_file "$INSTALLDIR/scripts/agentctl.sh"
_fixup_file "$INSTALLDIR/scripts/launchagentctl.sh"
_fixup_file "$INSTALLDIR/scripts/runAgent.sh"
# Create the icon resources
cd "$INSTALLDIR/scripts/images"
for i in `ls *.png`
do
    "$INSTALLDIR/installer/xdg/xdg-icon-resource" install --size 32 $i
done

chmod ugo+x "$INSTALLDIR/scripts/"*.sh

# Fixup the XDG files (don't just loop in case we have old entries we no longer want)
_fixup_file "$INSTALLDIR/scripts/xdg/pphq-pphq.directory"
_fixup_file "$INSTALLDIR/scripts/xdg/pphq-agent-start.desktop"
_fixup_file "$INSTALLDIR/scripts/xdg/pphq-agent-stop.desktop"

# Copy the primary desktop file to the branded version. We don't do this if
# the installation is not branded, to retain backwards compatibility.
cp "$INSTALLDIR/scripts/xdg/pphq-pphq.directory" "$INSTALLDIR/scripts/xdg/pphq-$BRANDING_STR.directory"

# Create the menu shortcuts - first the top level menu.
"$INSTALLDIR/installer/xdg/xdg-desktop-menu" install --mode system --noupdate \
    "$INSTALLDIR/scripts/xdg/pphq-$BRANDING_STR.directory" \
        "$INSTALLDIR/scripts/xdg/pphq-agent-start.desktop" \
        "$INSTALLDIR/scripts/xdg/pphq-agent-stop.desktop" || _warn "Failed to create the top level menu for Postgres Plus HQ agent"

echo "$0 ran to completion"
exit 0
