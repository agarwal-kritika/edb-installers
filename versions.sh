#!/bin/sh

# Source tarball versions

PG_TARBALL_POSTGRESQL=14.5
PG_TARBALL_PGADMIN=6.12
PG_TARBALL_DEBUGGER=0.93
PG_TARBALL_PLJAVA=1.4.0
PG_TARBALL_OPENSSL=1.1.1k
PG_TARBALL_ZLIB=1.2.8
PG_TARBALL_GEOS=3.8.1
PG_LP_VERSION=2.1

# Build nums
PG_BUILDNUM_APACHEPHP=1
PG_BUILDNUM_PGJDBC=1
PG_BUILDNUM_PSQLODBC=1
PG_BUILDNUM_POSTGIS=1
PG_BUILDNUM_SLONY=1
PG_BUILDNUM_NPGSQL=1
PG_BUILDNUM_PGAGENT=1
PG_BUILDNUM_PGMEMCACHE=1
PG_BUILDNUM_PGBOUNCER=1
PG_BUILDNUM_SQLPROTECT=1
PG_BUILDNUM_LANGUAGEPACK=1
PG_BUILDNUM_LANGUAGEPACK_PEM=3 #LP10
PG_BUILDNUM_PEMHTTPD=1

# PostgreSQL version. This is split into major version (8.4) and minor version (0.1).
#                     Minor version is revision.build.

PG_MAJOR_VERSION=14
PG_MINOR_VERSION=5.1

# Other package versions
PG_VERSION_APACHE=2.4.39
PG_VERSION_WSGI=4.4.23
PG_VERSION_PGJDBC=42.2.16
PG_VERSION_PSQLODBC=10.02.0000
PG_VERSION_POSTGIS=3.1.3
PG_VERSION_POSTGIS_JAVA=2.1.7.2
PG_VERSION_SLONY=2.2.10
PG_VERSION_NPGSQL=3.2.6
PG_VERSION_PGAGENT=4.2.2
PG_VERSION_PGMEMCACHE=2.3.0
PG_VERSION_PGBOUNCER=1.9.0
PG_VERSION_SQLPROTECT=$PG_TARBALL_POSTGRESQL
PG_VERSION_LANGUAGEPACK_PEM=10 # LP10
PG_VERSION_PYTHON_PEM=3.4 #LP10
PG_VERSION_PGADMIN=$PG_TARBALL_PGADMIN
PG_VERSION_SB=4.1.0

PG_VERSION_PERL=5.34
PG_MINOR_VERSION_PERL=0
PG_VERSION_PERL_WINDOWS64=5.26 # [PPS-363] - For LanguagePack-v2.0 We bundle different Perl version on Windows64 and macOS
PG_MINOR_VERSION_PERL_WINDOWS64=2
PG_VERSION_PYTHON=3.9
PG_MINOR_VERSION_PYTHON=13
#PG_VERSION_DIST_PYTHON=0.7.3
#PG_VERSION_DIST_PYTHON=0.6.49
PG_VERSION_TCL=8.6
PG_MINOR_VERSION_TCL=12
PG_VERSION_NCURSES=6.0
PG_VERSION_LANGUAGEPACK=$PG_LP_VERSION
PG_VERSION_PYTHON_SETUPTOOLS=57.0.0
VCREDIST_VERSION=14.15.26706

# This is required TCL and Tk Compiling for external tools.
# As this come from source code, we need to use it from the vcproj file
PG_PYTHON_TCL_TK=8.6.9.0
PG_PYTHON_TIX=8.4.3

# Miscellaneous options

# PostgreSQL jdbc jar version used by PostGIS
PG_JAR_POSTGRESQL=$PG_VERSION_PGJDBC.jdbc41
BASE_URL=http://sbp.enterprisedb.com
JRE_VERSIONS_LIST="$PG_MAJOR_VERSION;9.1;9.0"
