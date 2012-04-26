@echo off
REM Copyright (c) 2012, EnterpriseDB Corporation.  All rights reserved

REM PostgreSQL server psql runner script for Windows

SET server=localhost
SET /P server="Server [%server%]: "

SET database=postgres
SET /P database="Database [%database%]: "

SET port=PG_PORT
SET /P port="Port [%port%]: "

SET username=PG_USERNAME
SET /P username="Username [%username%]: "

REM Run psql
"PG_INSTALLDIR\bin\psql.exe" -h %server% -U %username% -d %database% -p %port%

pause
