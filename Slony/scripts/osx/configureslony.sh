#!/bin/bash

PGHOME=$1

#Copying the lib files to pkglibdir
libdir=`$PGHOME/bin/pg_config --pkglibdir`
mv -f $PGHOME/lib/slony1_funcs.so $libdir/
mv -f $PGHOME/lib/xxid.so $libdir/

#Copying the share files to sharedir
sharedir=`$PGHOME/bin/pg_config --sharedir`

#Creating file removal scripts to run at the time of uninstallation
filelist=`ls $PGHOME/share/Slony/`
echo "#!/bin/bash" > $PGHOME/Slony/installer/Slony/removeFiles.sh
echo "#Remove these files installed in the lib directory" >> $PGHOME/Slony/installer/Slony/removeFiles.sh
echo "rm -rf $libdir/xxid.so" >>  $PGHOME/Slony/installer/Slony/removeFiles.sh
echo "rm -rf $libdir/slony1_funcs.so" >> $PGHOME/Slony/installer/Slony/removeFiles.sh
echo "#Remove these files installed in the share directory" >> $PGHOME/Slony/installer/Slony/removeFiles.sh
for f in $filelist
do
   echo "rm -rf $sharedir/$f" >> $PGHOME/Slony/installer/Slony/removeFiles.sh
done
chmod ugo+x $PGHOME/Slony/installer/Slony/removeFiles.sh

mv -f $PGHOME/share/Slony/* $sharedir/
rm -rf $PGHOME/share/Slony

#Rewriting the slony binaries references
sudo install_name_tool -change "libpq.5.dylib" "$1/lib/libpq.5.dylib" "$1/bin/slon"
sudo install_name_tool -change "libpq.5.dylib" "$1/lib/libpq.5.dylib" "$1/bin/slonik"
sudo install_name_tool -change "libpq.5.dylib" "$1/lib/libpq.5.dylib" "$1/bin/slony_logshipper"

