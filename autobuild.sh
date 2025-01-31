#!/bin/sh

# pgInstaller auto build script
# Dave Page, EnterpriseDB

BASENAME=`basename $0`
DIRNAME=`dirname $0`

declare -a PACKAGES_ARR=(SERVER PGJDBC PSQLODBC POSTGIS SLONY NPGSQL PGAGENT PGMEMCACHE PGBOUNCER SQLPROTECT LANGUAGEPACK AHDFS_FDW PEMHTTPD PEM)
declare -a PLATFORMS_ARR=(LINUX LINUX_X64 WINDOWS WINDOWS_X64 OSX)
declare -a ENABLED_PKG_ARR=()
declare -a ENABLED_PLAT_ARR=()
declare -a DECOUPLED_ARR=(PGJDBC PSQLODBC NPGSQL PGBOUNCER PEMHTTPD LANGUAGEPACK PEM)
# Any changes to this file should be made to all the git branches.

usage()
{
        echo "Usage: $BASENAME [Options]\n"
        echo "    Options:"
        echo "      [-skipbuild boolean]" boolean value may be either "1" or "0"
        echo "      [-skippvtpkg boolean]" boolean value may be either "1" or "0"
        echo "      [-platforms list]  list of platforms. It may include the list of supported platforms separated by comma or all" 
        echo "      [-packages list]   list of packages. It may include the list of supported platforms separated by comma or all"
        echo "      [-releasebuild boolean] Used to distinguish between daily builds and release builds. A boolean value may be either true or false"
        echo "    Examples:"
        echo "     $BASENAME -skipbuild 0 -platforms "linux, linux_64, windows, windows_x64, osx" -packages "server, pemhttpd, pgjdbc, psqlodbc, slony, postgis, npgsql, pgagent, pgmemcache, pgbouncer, sqlprotect""
        echo "     $BASENAME -skipbuild 1 -platforms "all" -packages "all""
        echo "     $BASENAME -skipbuild 1 -skippvtpkg 1 -platforms "all" -packages "all""
        echo ""
        echo "    Note: setting skipbuild to 1 will skip the product build and just create the installer. 'all' option for -packages and -platforms will set all platforms and packages."
        echo "    Note: setting skippvtpkg to 1 will skip the private package build and installers"
        echo ""
        exit 1;
}

# command line arguments
while [ "$#" -gt "0" ]; do
        case "$1" in
                -skipbuild) SKIPBUILD=$2; shift 2;;
                -platforms) PLATFORMS=$2; shift 2;;
                -packages) PACKAGES=$2; shift 2;;
                -skippvtpkg) SKIPPVTPACKAGES=$2; shift 2;;
                -releasebuild) RELEASEBUILD=$2; shift 2;;
                -help|-h) usage;;
                *) echo -e "error: no such option $1. -h for help"; exit 1;;
        esac
done

# platforms variable value cannot be empty.
if [ "$PLATFORMS" = "" ]
then
        echo "Error: Please specify the platforms list"
        exit 2
fi

# packages variable value cannot be empty.
if [ "$PACKAGES" = "" ]
then
        echo "Error: Please specify the packages list"
        exit 3
fi

# required by build.sh
if $SKIPBUILD ;
then
	SKIPBUILD="-skipbuild"
else
	SKIPBUILD=""
fi

# required by build.sh
if $SKIPPVTPACKAGES ;
then
        SKIPPVTPACKAGES="-skippvtpkg"
else
        SKIPPVTPACKAGES=""
	# Make sure, we always do a full private build
	if [ -f pvt_settings.sh.full.REL-14 ]; then
		cp -f pvt_settings.sh.full.REL-14 pvt_settings.sh.REL-14
	fi
fi

_set_config_package()
{
	if echo $PACKAGES | grep -w -i $1 > /dev/null
        then
		export PG_PACKAGE_$1=1
		ENABLED_PKG_ARR+=( $1 )
	else
		export PG_PACKAGE_$1=0
	fi
}

_set_config_platform()
{
	if echo $PLATFORMS | grep -w -i $1 > /dev/null
	then
		export PG_ARCH_$1=1
		ENABLED_PLAT_ARR+=( $1 )
	else
		export PG_ARCH_$1=0
        fi
}
#check if value is enabled or disabled in setting.sh file
IsValueEnabled(){
        searchStr=$1
        varStatus=`cat settings.sh | grep -w $1 | cut -f 3 -d ' '`
        echo $varStatus
}
# Query if component is coupled
IsCoupled(){
        componentName=$1
        [[ ! " ${DECOUPLED_ARR[@]} " =~ " ${componentName} " ]] && return 0 || return 1;
}

#If the platforms list is defined as 'all', then no need to set the config variables. settings.sh will take care of it.
if ! echo $PLATFORMS | grep -w -i all > /dev/null
then
        for PLAT in "${PLATFORMS_ARR[@]}";
        do
                _set_config_platform $PLAT
        done
else
        for plat in "${PLATFORMS_ARR[@]}";
        do
                rValue=$(IsValueEnabled PG_ARCH_$plat)
                if [[ $rValue == 1 ]]; then
                        ENABLED_PLAT_ARR+=( $plat )
                fi
        done
fi

#If the packages list is defined as 'all', then no need to set the config variables. settings.sh will take care of it.
if ! echo $PACKAGES | grep -w -i all > /dev/null
then
        for pkg in "${PACKAGES_ARR[@]}";
        do
                _set_config_package $pkg
        done
else
        for pkg in "${PACKAGES_ARR[@]}";
        do
                rValue=$(IsValueEnabled PG_PACKAGE_$pkg)
                if [[ $rValue == 1 ]]; then
                        ENABLED_PKG_ARR+=( $pkg )
                fi
        done
fi

# Generic mail variables
log_location="/home/buildfarm/pginstaller14.auto/output"
header_fail="Autobuild failed with the following error (last 20 lines of the log):
###################################################################################"
footer_fail="###################################################################################"

# Mail function
_mail_status()
{
        build_filename=$1
        pvtbuild_filename=$2
        version=$3
        build_log_file=$log_location/$build_filename
        pvtbuild_log_file=$log_location/$pvtbuild_filename

        build_log_content=`tail -20 $build_log_file`
	build_error_flag=`echo $build_log_content | grep "FATAL ERROR"`
	
	if [ -f $pvtbuild_log_file ]
        then
           pvtbuild_log_content=`tail -20 $pvtbuild_log_file`
           pvtbuild_error_flag=`echo $pvtbuild_log_content | grep "FATAL ERROR"`

        fi

        if [ ${#build_error_flag} -gt 0 ]
        then
                log_content=$build_log_content
        elif [ ${#pvtbuild_error_flag} -gt 0 ]
        then
                log_content=$pvtbuild_log_content
        fi

        if [ "x$build_error_flag" = "x" ] && [ "x$pvtbuild_error_flag" = "x" ]
        then
                mail_content="Autobuild completed Successfully."
                build_status="SUCCESS"
                mail_receipents="sandeep.thakkar@enterprisedb.com"
        else
                mail_content="
$header_fail

$log_content

$footer_fail"
                build_status="FAILED"
                if [ ${#build_error_flag} -gt 0 ]
                then
                        mail_receipents="-c cm@enterprisedb.com"
                elif [ ${#pvtbuild_error_flag} -gt 0 ]
                then
                        mail_receipents="-c cm@enterprisedb.com"
                fi
        fi

        mutt -s "pgInstaller Build $version ($country) - $build_status" $mail_receipents <<EOT
$mail_content
EOT
}

# Get build location
GetBuildsLocation()
{
    OS_UNAME_INFO=$(uname -a)
    MACHINE_OS_WINDOWS=`echo "$OS_UNAME_INFO" | grep "Msys\|Cygwin"`

    if [ -n "$MACHINE_OS_WINDOWS" ]
    then
        cmd /C "ipconfig /all" > tmp.txt
        dns=$(cat tmp.txt | grep "DNS Servers" | cut -d":" -f2 | cut -f2,3 -d".")
        rm -f tmp.txt
    else
        dns=$(grep -w "172" /etc/resolv.conf | cut -f2,3 -d".")
    fi

    if [[ "$dns" == "24.32" || "$dns" == "16.208" || "$dns" == "16.209" || "$dns" == "16.1" ]];
    then
            COUNTRY="UK"
    elif [[ "$dns" == "24.35" || "$dns" == "24.34" || "$dns" == "19.5" || "$dns" == "24.5" ]];
    then
            COUNTRY="IN"
    elif [[ "$dns" == "24.36" ]];
    then
            COUNTRY="PK"
    elif [[ "$dns" == "22.5" ]];
    then
            COUNTRY="US"
    else
            COUNTRY="UN"
    fi

    #echo $dns
    echo $COUNTRY
}

# Run everything from the root of the buld directory
cd $DIRNAME

echo "#######################################################################" >> autobuild.log
echo "Build run starting at `date`" >> autobuild.log
echo "#######################################################################" >> autobuild.log

#Get the date in the beginning to maintain consistency.
DATE=`date +'%Y-%m-%d'`

# Clear out any old output
echo "Cleaning up old output" >> autobuild.log
rm -rf output/* >> autobuild.log 2>&1

# Switch to REL-14 branch
echo "Switching to REL-14 branch" >> autobuild.log
git reset --hard >> autobuild.log 2>&1
git checkout REL-14 >> autobuild.log 2>&1

# Make sure, we always do a full build
if [ -f settings.sh.full.REL-14 ]; then
   cp -f settings.sh.full.REL-14 settings.sh
fi

# Self update
echo "Updating REL-14 branch build system" >> autobuild.log
git pull >> autobuild.log 2>&1

# Run the build, and dump the output to a log file
echo "Running the build (REL-14) " >> autobuild.log
./build.sh $SKIPBUILD $SKIPPVTPACKAGES 2>&1 | tee output/build-14.log

VERSION_NUMBER=`cat versions.sh | grep PG_MAJOR_VERSION= | cut -f 2 -d '='`
STR_VERSION_NUMBER=`echo $VERSION_NUMBER | sed 's/\.//'`

# determine the host location
country="$(GetBuildsLocation)"

#-------------------
GetPkgDirName(){
        COMP_NAME=$1
        PACKAGES=${COMP_NAME,,}
        SERVER_VERSION=$STR_VERSION_NUMBER
        if ! (IsCoupled $COMP_NAME); then
                COMP_VERSION=`cat versions.sh | grep PG_VERSION_$COMP_NAME= | cut -f1,2 -d "." | cut -f 2 -d '='`
		if [[ $PACKAGES == *"languagepack"* ]]; then
                        COMP_VERSION=`cat versions.sh | grep PG_LP_VERSION= | cut -f1,2 -d "." | cut -f 2 -d '='`
                fi
                if [[ $COMP_VERSION == *"PG_MAJOR_VERSION"* ]]; then
                        COMP_VERSION_NUMBER=$SERVER_VERSION
                else
                        COMP_VERSION_NUMBER=$COMP_VERSION
                fi
                P_NAME=$PACKAGES/$COMP_VERSION_NUMBER
        else
                P_NAME=postgresql/$SERVER_VERSION
        fi
        echo ${P_NAME,,}
}

#------------------
GetInstallerName(){
        pkg_name=${1,,}
        if [[ $pkg_name == *"server"* ]]; then
                installerName=postgresql
        elif [[ $pkg_name == *"update_monitor"* ]]; then
                installerName=updatemonitor
        elif [[ $pkg_name == *"pemhttpd"* ]]; then
                installerName=pem-httpd
        else
                installerName=$pkg_name
        fi
        echo ${installerName,,}
}
#------------------
_mail_status "build-14.log" "build-pvt.log" "14"
#------------------
CopyToBuilds(){
        PACKAGE_NAME=$1
        PLATFORM_NAME=${2,,}
        country=${country,,}
        PKG_NAME=$(GetPkgDirName $PACKAGE_NAME)
        remote_location="/mnt/builds/daily-builds/$country/pg/$PKG_NAME"
        echo "Purging old builds from the builds server" >> autobuild.log

       ssh builds.enterprisedb.com <<EOF

            pushd $remote_location || exit 1

            ToKeepDir=15

            DirCount=\$(ls -rt | wc -l)

            if [ "\$DirCount" -gt  "\$ToKeepDir" ];
            then
                ls -rt | head -\$(expr \$DirCount - \$ToKeepDir) | grep 201 | xargs -I{} rm -rf {}
            fi
EOF

        # Different location for the manual and cron triggered builds.
        if [ "$BUILD_USER" == "" ] || [ "$BUILD_USER" == "Timer Trigger" ];
        then
                echo "Host country = $country" >> autobuild.log
                remote_location="$remote_location/$DATE/installer/$PLATFORM_NAME"
        else
                build_user=$BUILD_USER
                # Search for any possible spaces from user name and replace them with a Dot (.)
                if [[ $build_user = *" "*  ]];
                then
                    build_user="${build_user// /.}"
                fi
                remote_location="$remote_location/custom/$build_user/$DATE/$BUILD_NUMBER/installers/$PLATFORM_NAME"
        fi
        # Create a remote directory if not present
        platInstallerName=`echo $PLATFORM_NAME | sed 's/_/-/'`
	if  [[ $platInstallerName == *"osx"* ]] || [[ $platInstallerName == *"x64"* ]]; then
		platInstallerName=${platInstallerName}*.*
	else
		platInstallerName=${platInstallerName}.*
	fi
	installername=$( GetInstallerName $PACKAGE_NAME )
	if $RELEASEBUILD ; then
		remote_location="/mnt/builds/builds-for-qmg/pg/$PKG_NAME"
	fi

	echo "Creating $remote_location on the builds server" >> autobuild.log
        ssh buildfarm@builds.enterprisedb.com mkdir -p $remote_location >> autobuild.log 2>&1

        echo "Uploading output to $remote_location on the builds server" >> autobuild.log
	scp -r output/*${installername}*${platInstallerName} output/3rd_party_libraries_list output/symbols output/build-14.log buildfarm@builds.enterprisedb.com:$remote_location >> autobuild.log 2>&1
}
# Copy Installers to Build
for PLAT in "${ENABLED_PLAT_ARR[@]}";
do
        for PKG in "${ENABLED_PKG_ARR[@]}";
        do
                CopyToBuilds $PKG $PLAT
        done
done
echo "#######################################################################" >> autobuild.log
echo "Build run completed at `date`" >> autobuild.log
echo "#######################################################################" >> autobuild.log
echo "" >> autobuild.log
