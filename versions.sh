#!/bin/sh
 
# Source tarball versions

PG_TARBALL_POSTGRESQL=8.4.12
PG_TARBALL_PGADMIN=1.10.5
PG_TARBALL_DEBUGGER=0.93
PG_TARBALL_PLJAVA=1.4.0
PG_TARBALL_OPENSSL=0.9.8l
PG_TARBALL_ZLIB=1.2.3
PG_TARBALL_GEOS=3.2.1
PG_TARBALL_PROJ=4.6.1
PG_TARBALL_LIBMEMCACHED=0.32
PG_TARBALL_LIBEVENT=1.4.13-stable

# Build nums
PG_BUILDNUM_PGJDBC=1
PG_BUILDNUM_PSQLODBC=1
PG_BUILDNUM_POSTGIS=1
PG_BUILDNUM_SLONY=1
PG_BUILDNUM_NPGSQL=1
PG_BUILDNUM_PGAGENT=4
PG_BUILDNUM_PGMEMCACHE=1
PG_BUILDNUM_PGBOUNCER=5
PG_BUILDNUM_LIBPQ=1
PG_BUILDNUM_SBP=4
PG_BUILDNUM_MIGRATIONTOOLKIT=3
PG_BUILDNUM_REPLICATIONSERVER=1
PG_BUILDNUM_PLPGSQLO=1

# Tags for source checkout
PG_TAG_REPLICATIONSERVER=''
PG_TAG_MIGRATIONTOOLKIT=''

# PostgreSQL version. This is split into major version (8.4) and minor version (0.1).
#                     Minor version is revision.build. 

PG_MAJOR_VERSION=8.4
PG_MINOR_VERSION=12.1

# Other package versions
PG_VERSION_PGJDBC=8.4-702
PG_VERSION_PSQLODBC=08.04.0200
PG_VERSION_POSTGIS=1.4.2
PG_VERSION_SLONY=2.0.7
PG_VERSION_NPGSQL=2.0.8
PG_VERSION_PGAGENT=3.0.1
PG_VERSION_METAINSTALLER=$PG_MAJOR_VERSION
PG_VERSION_PGMEMCACHE=2.0.1
PG_VERSION_PGBOUNCER=1.3.3
PG_VERSION_LIBPQ=$PG_TARBALL_POSTGRESQL
PG_VERSION_SBP=2.0.0
PG_VERSION_MIGRATIONTOOLKIT=1.0
PG_VERSION_REPLICATIONSERVER=2.56
PG_VERSION_PLPGSQLO=$PG_TARBALL_POSTGRESQL

# Miscellaneous options

# PostgreSQL jdbc jar version used by PostGIS
PG_JAR_POSTGRESQL=8.4-702.jdbc3

# Dependent Packages for Postgres Plus HQ
PPHQ_JBOSS_VERSION=4.2.3.GA
PPHQ_ANT_VERSION=1.7.1


