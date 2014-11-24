#!/bin/sh

# Source tarball versions

PG_TARBALL_POSTGRESQL=9.4rc1
PG_TARBALL_PGADMIN=1.20.0-rc1
PG_TARBALL_DEBUGGER=0.93
PG_TARBALL_PLJAVA=1.4.0
PG_TARBALL_OPENSSL=1.0.1j
PG_TARBALL_ZLIB=1.2.8
PG_TARBALL_GEOS=3.4.2

# Build nums
PG_BUILDNUM_APACHEPHP=1
PG_BUILDNUM_PHPPGADMIN=1
PG_BUILDNUM_PGJDBC=1
PG_BUILDNUM_PSQLODBC=1
PG_BUILDNUM_POSTGIS=1
PG_BUILDNUM_SLONY=1
PG_BUILDNUM_NPGSQL=1
PG_BUILDNUM_PGAGENT=1
PG_BUILDNUM_PGMEMCACHE=1
PG_BUILDNUM_PGBOUNCER=2
PG_BUILDNUM_MIGRATIONTOOLKIT=1
PG_BUILDNUM_REPLICATIONSERVER=2
PG_BUILDNUM_PLPGSQLO=1
PG_BUILDNUM_SQLPROTECT=1
PG_BUILDNUM_UPDATE_MONITOR=3

# Tags for source checkout
PG_TAG_REPLICATIONSERVER=''
PG_TAG_MIGRATIONTOOLKIT=''

# PostgreSQL version. This is split into major version (8.4) and minor version (0.1).
#                     Minor version is revision.build.

PG_MAJOR_VERSION=9.4
PG_MINOR_VERSION=0.rc1

# Other package versions
PG_VERSION_APACHE=2.4.10
PG_VERSION_PHP=5.5.19
PG_VERSION_PHPPGADMIN=5.1
PG_VERSION_PGJDBC=9.3-1100
PG_VERSION_PSQLODBC=09.03.0300
PG_VERSION_POSTGIS=2.1.4
PG_VERSION_SLONY=2.2.3
PG_VERSION_NPGSQL=2.2.1
PG_VERSION_PGAGENT=3.4.0
PG_VERSION_PGMEMCACHE=2.1.2
PG_VERSION_PGBOUNCER=1.5.4
PG_VERSION_MIGRATIONTOOLKIT=48.0.0
PG_VERSION_REPLICATIONSERVER=5.0
PG_VERSION_PLPGSQLO=$PG_TARBALL_POSTGRESQL
PG_VERSION_SQLPROTECT=$PG_TARBALL_POSTGRESQL
PG_VERSION_UPDATE_MONITOR=1.0

# Miscellaneous options

# PostgreSQL jdbc jar version used by PostGIS
PG_JAR_POSTGRESQL=9.2-1000.jdbc4
BASE_URL=http://sbp.enterprisedb.com
JRE_VERSIONS_LIST="$PG_MAJOR_VERSION;9.1;9.0"
