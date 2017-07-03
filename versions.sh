#!/bin/sh

# Source tarball versions

PG_TARBALL_POSTGRESQL=9.6.3
PG_TARBALL_PGADMIN=1.5
PG_TARBALL_DEBUGGER=0.93
PG_TARBALL_PLJAVA=1.4.0
PG_TARBALL_OPENSSL=1.0.2l
PG_TARBALL_ZLIB=1.2.8
PG_TARBALL_GEOS=3.5.0

# Build nums
PG_BUILDNUM_APACHEPHP=1
PG_BUILDNUM_PHPPGADMIN=2
PG_BUILDNUM_PGJDBC=1
PG_BUILDNUM_PSQLODBC=1
PG_BUILDNUM_POSTGIS=2
PG_BUILDNUM_SLONY=2
PG_BUILDNUM_NPGSQL=2
PG_BUILDNUM_PGAGENT=3
PG_BUILDNUM_PGMEMCACHE=2
PG_BUILDNUM_PGBOUNCER=2
PG_BUILDNUM_SQLPROTECT=2
PG_BUILDNUM_UPDATE_MONITOR=5
PG_BUILDNUM_LANGUAGEPACK=2
PG_BUILDNUM_PEMHTTPD=1
PG_BUILDNUM_HDFS_FDW=1
PG_BUILDNUM_LANGUAGEPACK_PEM=2 #LP10

# Tags for source checkout
PG_TAG_MIGRATIONTOOLKIT=''

# PostgreSQL version. This is split into major version (8.4) and minor version (0.1).
#                     Minor version is revision.build.

PG_MAJOR_VERSION=9.6
PG_MINOR_VERSION=3.2

# Other package versions
PG_VERSION_APACHE=2.4.26
PG_VERSION_WSGI=4.4.23
PG_VERSION_PHP=5.5.30
PG_VERSION_PHPPGADMIN=5.1
PG_VERSION_PGJDBC=42.1.1
PG_VERSION_PSQLODBC=09.06.0310
PG_VERSION_POSTGIS=2.3.2
PG_VERSION_POSTGIS_JAVA=2.1.7.2
PG_VERSION_SLONY=2.2.5
PG_VERSION_NPGSQL=3.0.8
PG_VERSION_PGAGENT=3.4.0
PG_VERSION_PGMEMCACHE=2.3.0
PG_VERSION_PGBOUNCER=1.7.2
PG_VERSION_MIGRATIONTOOLKIT=48.0.0
PG_VERSION_SQLPROTECT=$PG_TARBALL_POSTGRESQL
PG_VERSION_UPDATE_MONITOR=1.0
PG_VERSION_HDFS_FDW=2.0
PG_VERSION_LANGUAGEPACK_PEM=10 # LP10
PG_VERSION_PYTHON_PEM=3.4 #LP10

PG_VERSION_PERL=5.20
PG_MINOR_VERSION_PERL=3
PG_VERSION_PYTHON=3.3
PG_MINOR_VERSION_PYTHON=4
PG_VERSION_DIST_PYTHON=0.6.49
PG_VERSION_TCL=8.5
PG_MINOR_VERSION_TCL=17
PG_VERSION_NCURSES=5.9
PG_VERSION_LANGUAGEPACK=$PG_MAJOR_VERSION

# Tags for source checkout
PG_TAG_HDFS_FDW=''
# Target JRE version
TARGET_JRE_VERSION=1.7

# Miscellaneous options

# PostgreSQL jdbc jar version used by PostGIS
PG_JAR_POSTGRESQL=$PG_VERSION_PGJDBC.jdbc41
BASE_URL=http://sbp.enterprisedb.com
JRE_VERSIONS_LIST="$PG_MAJOR_VERSION;9.1;9.0"
