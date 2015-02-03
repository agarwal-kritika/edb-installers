#!/bin/sh

# Source tarball versions

PG_TARBALL_POSTGRESQL=9.0.19
PG_TARBALL_PGADMIN=1.12.3
PG_TARBALL_DEBUGGER=0.93
PG_TARBALL_PLJAVA=1.4.0
PG_TARBALL_OPENSSL=1.0.1a
PG_TARBALL_ZLIB=1.2.3
PG_TARBALL_GEOS=3.3.0
PG_TARBALL_PROJ=4.7.0
PG_TARBALL_LIBMEMCACHED=0.51
PG_TARBALL_LIBEVENT=1.4.13-stable

# Build nums
PG_BUILDNUM_POSTGIS=2
PG_BUILDNUM_SLONY=1
PG_BUILDNUM_PGMEMCACHE=2
PG_BUILDNUM_PGBOUNCER=4
PG_BUILDNUM_SBP=3
PG_BUILDNUM_MIGRATIONTOOLKIT=4
PG_BUILDNUM_JBOSS=1
PG_BUILDNUM_REPLICATIONSERVER=1
PG_BUILDNUM_PLPGSQLO=1
PG_BUILDNUM_SQLPROTECT=2

# Tags for source checkout
PG_TAG_REPLICATIONSERVER=''
PG_TAG_MIGRATIONTOOLKIT='AS90R1_90414'

# PostgreSQL version. This is split into major version (8.4) and minor version (0.1).
#                     Minor version is revision.build.

PG_MAJOR_VERSION=9.0
PG_MINOR_VERSION=19.1

# Other package versions
PG_VERSION_PGJDBC=9.0-801
PG_VERSION_POSTGIS=1.5.8
PG_VERSION_SLONY=2.0.8
PG_VERSION_PGMEMCACHE=2.0.6
PG_VERSION_PGBOUNCER=1.3.3
PG_VERSION_SBP=2.0.0
PG_VERSION_MIGRATIONTOOLKIT=1.0
PG_VERSION_JBOSS=4.2.3
PG_VERSION_REPLICATIONSERVER=2.52
PG_VERSION_PLPGSQLO=$PG_TARBALL_POSTGRESQL
PG_VERSION_SQLPROTECT=$PG_TARBALL_POSTGRESQL

# Miscellaneous options

# PostgreSQL jdbc jar version used by PostGIS
PG_JAR_POSTGRESQL=9.0-801.jdbc3

# Dependent Packages for Postgres Plus HQ
PPHQ_JBOSS_VERSION=4.2.3.GA
PPHQ_ANT_VERSION=1.7.1
BASE_URL=http://sbp.enterprisedb.com

