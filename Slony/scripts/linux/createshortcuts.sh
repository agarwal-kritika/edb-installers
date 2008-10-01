#!/bin/sh

# Check the command line
if [ $# -ne 1 ]; 
then
    echo "Usage: $0 <Install dir> "
    exit 127
fi

INSTALLDIR="$1"

# Exit code
WARN=0

# Working directory
WD=`pwd`

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
    sed -e "s^$1^$2^g" "$3" > "/tmp/$$.tmp" || _die "Failed for search and replace '$1' with '$2' in $3"
    mv /tmp/$$.tmp "$3" || _die "Failed to move /tmp/$$.tmp to $3"
}

# Substitute values into a file ($in)
_fixup_file() {
    _replace INSTALL_DIR "$INSTALLDIR" "$1"
}

# Create the icon resources
cd "$INSTALLDIR/Slony/scripts/images"
for i in `ls *.png`
do
    "$INSTALLDIR/Slony/installer/xdg/xdg-icon-resource" install --size 32 --novendor $i
done

# Fixup the scripts
chmod ugo+x "$INSTALLDIR/Slony/installer/Slony/"*.sh
_fixup_file "$INSTALLDIR/Slony/scripts/launchSlonyDocs.sh"

chmod ugo+x "$INSTALLDIR/Slony/scripts/launchSlonyDocs.sh"

# Fixup the XDG files (don't just loop in case we have old entries we no longer want)
_fixup_file "$INSTALLDIR/Slony/scripts/xdg/enterprisedb-launchSlonyDocs.desktop"

chmod ugo+x "$INSTALLDIR/Slony/scripts/xdg/enterprisedb-launchSlonyDocs.desktop"
chmod ugo+x "$INSTALLDIR/Slony/scripts/xdg/enterprisedb-postgres.directory"

# Create the menu shortcuts - first the top level, then the documentation menu.
"$INSTALLDIR/Slony/installer/xdg/xdg-desktop-menu" install --mode system --novendor \
         "$INSTALLDIR/Slony/scripts/xdg/enterprisedb-postgres.directory" \
    "$INSTALLDIR/Slony/scripts/xdg/enterprisedb-launchSlonyDocs.desktop"  || _warn "Failed to create the Slony menu"

echo "$0 ran to completion"
exit 0
