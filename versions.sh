#!/bin/sh

# Source tarball versions

PG_TARBALL_POSTGRESQL=9.0.3
PG_TARBALL_PGADMIN=1.12.2
PG_TARBALL_DEBUGGER=0.93
PG_TARBALL_PLJAVA=1.4.0
PG_TARBALL_OPENSSL=0.9.8l
PG_TARBALL_ZLIB=1.2.3
PG_TARBALL_GEOS=3.2.2
PG_TARBALL_PROJ=4.7.0
PG_TARBALL_LIBMEMCACHED=0.38
PG_TARBALL_LIBEVENT=1.4.13-stable

# Build nums
PG_BUILDNUM_APACHEPHP=1
PG_BUILDNUM_MEDIAWIKI=1
PG_BUILDNUM_PHPBB=1
PG_BUILDNUM_DRUPAL=2
PG_BUILDNUM_PHPPGADMIN=1
PG_BUILDNUM_PGJDBC=1
PG_BUILDNUM_PSQLODBC=1
PG_BUILDNUM_POSTGIS=1
PG_BUILDNUM_SLONY=1
PG_BUILDNUM_TUNINGWIZARD=1
PG_BUILDNUM_MIGRATIONWIZARD=5
PG_BUILDNUM_PGPHONEHOME=3
PG_BUILDNUM_NPGSQL=1
PG_BUILDNUM_PGAGENT=3
PG_BUILDNUM_PGMEMCACHE=1
PG_BUILDNUM_PGBOUNCER=2
PG_BUILDNUM_LIBPQ=1
PG_BUILDNUM_SBP=5
PG_BUILDNUM_MIGRATIONTOOLKIT=4
PG_BUILDNUM_JBOSS=1
PG_BUILDNUM_PPHQ=3
PG_BUILDNUM_HQAGENT=$PG_BUILDNUM_PPHQ
PG_BUILDNUM_REPLICATIONSERVER=3
PG_BUILDNUM_PLPGSQLO=1
PG_BUILDNUM_SQLPROTECT=1

# Tags for source checkout
PG_TAG_REPLICATIONSERVER='AS90R1_90414'
PG_TAG_MIGRATIONTOOLKIT='AS90R1_90414'

# PostgreSQL version. This is split into major version (8.4) and minor version (0.1).
#                     Minor version is revision.build.

PG_MAJOR_VERSION=9.0
PG_MINOR_VERSION=3.1

# Other package versions
PG_VERSION_APACHE=2.2.17
PG_VERSION_PHP=5.3.5
PG_VERSION_MEDIAWIKI=1.16.1
PG_VERSION_PHPBB=3.0.8
PG_VERSION_DRUPAL=6.19
PG_VERSION_PHPPGADMIN=5.0.2
PG_VERSION_PGJDBC=8.4-702
PG_VERSION_PSQLODBC=09.00.0200
PG_VERSION_POSTGIS=1.5.2
PG_VERSION_SLONY=2.0.4
PG_VERSION_TUNINGWIZARD=1.4
PG_VERSION_MIGRATIONWIZARD=1.1
PG_VERSION_PGPHONEHOME=1.1
PG_VERSION_DEVSERVER=9.1alpha1
PG_VERSION_NPGSQL=2.0.11
PG_VERSION_PGAGENT=3.0.1
PG_VERSION_METAINSTALLER=$PG_MAJOR_VERSION
PG_VERSION_PGMEMCACHE=2.0.1
PG_VERSION_PGBOUNCER=1.5
PG_VERSION_LIBPQ=$PG_TARBALL_POSTGRESQL
PG_VERSION_SBP=$PG_MAJOR_VERSION.2.03
PG_VERSION_MIGRATIONTOOLKIT=1.0
PG_VERSION_JBOSS=4.2.3
PG_VERSION_PPHQ=4.2.0
PG_VERSION_HQAGENT=$PG_VERSION_PPHQ
PG_VERSION_REPLICATIONSERVER=$PG_MAJOR_VERSION.55
PG_VERSION_PLPGSQLO=$PG_TARBALL_POSTGRESQL
PG_VERSION_SQLPROTECT=$PG_TARBALL_POSTGRESQL

# Miscellaneous options

# PostgreSQL jdbc jar version used by PostGIS
PG_JAR_POSTGRESQL=8.4-702.jdbc3

# Dependent Packages for Postgres Plus HQ
PPHQ_JBOSS_VERSION=4.2.3.GA
PPHQ_ANT_VERSION=1.7.1


