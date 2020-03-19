#!/bin/sh

# Source tarball versions

PG_TARBALL_POSTGRESQL=11.7
PG_TARBALL_PGADMIN=4.18
PG_TARBALL_DEBUGGER=0.93
PG_TARBALL_PLJAVA=1.4.0
PG_TARBALL_OPENSSL=1.0.2s
PG_TARBALL_ZLIB=1.2.8
PG_TARBALL_GEOS=3.7.0
PG_LP_VERSION=1.0

# Build nums
PG_BUILDNUM_APACHEPHP=1
PG_BUILDNUM_PHPPGADMIN=1
PG_BUILDNUM_PGJDBC=3
PG_BUILDNUM_PSQLODBC=1
PG_BUILDNUM_POSTGIS=2
PG_BUILDNUM_SLONY=3
PG_BUILDNUM_NPGSQL=1
PG_BUILDNUM_PGAGENT=3
PG_BUILDNUM_PGMEMCACHE=3
PG_BUILDNUM_PGBOUNCER=1
PG_BUILDNUM_SQLPROTECT=3
PG_BUILDNUM_UPDATE_MONITOR=4
PG_BUILDNUM_LANGUAGEPACK=3
PG_BUILDNUM_APACHEHTTPD=1
PG_BUILDNUM_HDFS_FDW=1
PG_BUILDNUM_LANGUAGEPACK_PEM=3 #LP10
PG_BUILDNUM_PEMHTTPD=1

# Tags for source checkout
PG_TAG_MIGRATIONTOOLKIT=''

# PostgreSQL version. This is split into major version (8.4) and minor version (0.1).
#                     Minor version is revision.build.

PG_MAJOR_VERSION=11
PG_MINOR_VERSION=7.2

# Other package versions
PG_VERSION_APACHE=2.4.39
PG_VERSION_WSGI=4.4.23
PG_VERSION_PHP=5.5.30
PG_VERSION_PHPPGADMIN=5.1
PG_VERSION_PGJDBC=42.2.5
PG_VERSION_PSQLODBC=10.02.0000
PG_VERSION_POSTGIS=2.5.3
PG_VERSION_POSTGIS_JAVA=2.1.7.2
PG_VERSION_SLONY=2.2.7
PG_VERSION_NPGSQL=3.2.6
PG_VERSION_PGAGENT=4.0.0
PG_VERSION_PGMEMCACHE=2.3.0
PG_VERSION_PGBOUNCER=1.9.0
PG_VERSION_MIGRATIONTOOLKIT=48.0.0
PG_VERSION_SQLPROTECT=$PG_TARBALL_POSTGRESQL
PG_VERSION_UPDATE_MONITOR=1.0
PG_VERSION_HDFS_FDW=1.0
PG_VERSION_LANGUAGEPACK_PEM=10 # LP10
PG_VERSION_PYTHON_PEM=3.4 #LP10
PG_VERSION_PGADMIN=$PG_TARBALL_PGADMIN
PG_VERSION_SB=4.1.0

PG_VERSION_PERL=5.26
PG_MINOR_VERSION_PERL=2
PG_VERSION_PYTHON=3.7
PG_MINOR_VERSION_PYTHON=4
#PG_VERSION_DIST_PYTHON=0.7.3
#PG_VERSION_DIST_PYTHON=0.6.49
PG_VERSION_TCL=8.6
PG_MINOR_VERSION_TCL=8
PG_VERSION_NCURSES=6.0
PG_VERSION_LANGUAGEPACK=$PG_LP_VERSION
PG_VERSION_PYTHON_SETUPTOOLS=39.2.0
VCREDIST_VERSION=14.15.26706

# Miscellaneous options

# PostgreSQL jdbc jar version used by PostGIS
PG_JAR_POSTGRESQL=$PG_VERSION_PGJDBC.jdbc41
BASE_URL=http://sbp.enterprisedb.com
JRE_VERSIONS_LIST="$PG_MAJOR_VERSION;9.1;9.0"
