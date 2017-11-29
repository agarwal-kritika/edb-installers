@ECHO OFF

CALL "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" amd64

SET vPythonBuildDir=%1
SET vPythonInstallDir=%2
SET vScriptsDir=%3
SET vTclInstallDir=%4
SET vXZDir=%5
SET vOpenSSLDir=%6
SET vPgBuildDir=%7
 
ECHO vPythonBuildDir ----  %vPythonBuildDir%
ECHO vPythonInstallDir ---- %vPythonInstallDir%
ECHO vScriptsDir ---- %vScriptsDir%
ECHO vTclInstallDir ----  %vTclInstallDir%
ECHO vXZDir ----  %vXZDir%
ECHO vOpenSSLDir ----  %vOpenSSLDir%

CD %vPythonBuildDir%\PCbuild
devenv.exe /upgrade %vPythonBuildDir%\PCbuild\pcbuild.sln

CD %vPythonBuildDir%

ECHO Executing batach file %vPythonBuildDir%\Tools\buildbot\external-common.bat
CALL %vPythonBuildDir%\Tools\buildbot\external-common.bat

CD %vPythonBuildDir%\PCbuild
msbuild pcbuild.sln /p:Configuration=Release /p:PlatformToolset=v120_xp /p:tcltk64Dir="%vTclInstallDir%" /p:tcltk64Lib="%vTclInstallDir%\lib\tcl85.lib;%vTclInstallDir%\lib\tk85.lib" /p:lzmaDir="%vXZDir%" /p:opensslDir="%vOpenSSLDir%"

ECHO copying py*.exe from %vPythonBuildDir%\PCbuild\ to %vPythonInstallDir%\
XCOPY /f /y %vPythonBuildDir%\PCbuild\py*.exe %vPythonInstallDir%\

ECHO copying py*.exe from %vPythonBuildDir%\PCbuild\amd64 to %vPythonInstallDir%\
XCOPY /f /y %vPythonBuildDir%\PCbuild\amd64\py*.exe %vPythonInstallDir%\

ECHO copying py*.dll from %vPythonBuildDir%\PCbuild\amd64 to %vPythonInstallDir% 
XCOPY /f /y %vPythonBuildDir%\PCbuild\amd64\py*.dll %vPythonInstallDir%\

ECHO making DIR %vPythonInstallDir%\Include
mkdir %vPythonInstallDir%\Include

ECHO copying Files %vPythonBuildDir%\Include\* to %vPythonInstallDir%\Include\
XCOPY /e /Q /Y  %vPythonBuildDir%\Include\* %vPythonInstallDir%\Include\

ECHO making DIR %vPythonInstallDir%\Lib
mkdir %vPythonInstallDir%\Lib

ECHO copying Files %vPythonBuildDir%\Lib\* to %vPythonInstallDir%\Lib\
XCOPY /s /e /f /h %vPythonBuildDir%\Lib\* %vPythonInstallDir%\Lib\

ECHO making DIR %vPythonInstallDir%\Tools
mkdir %vPythonInstallDir%\Tools

ECHO copying Files %vPythonBuildDir%\Tools\* to %vPythonInstallDir%\Tools\
XCOPY /e /Q /Y %vPythonBuildDir%\Tools\* %vPythonInstallDir%\Tools\

ECHO copying errmap.h from %vPythonBuildDir%\PC\errmap.h to %vPythonInstallDir%\Include\
XCOPY /f /y %vPythonBuildDir%\PC\errmap.h %vPythonInstallDir%\Include\

ECHO copying pyconfig.h from %vPythonBuildDir%\PC\pyconfig.h to %vPythonInstallDir%\Include\
XCOPY /f /y  %vPythonBuildDir%\PC\pyconfig.h %vPythonInstallDir%\Include\

ECHO making DIR %vPythonInstallDir%\libs
mkdir %vPythonInstallDir%\libs

ECHO copying Files %vPythonBuildDir%\PCbuild\amd64\*.lib to %vPythonInstallDir%\libs\
XCOPY /f /y %vPythonBuildDir%\PCbuild\amd64\*.lib %vPythonInstallDir%\libs\

ECHO making DIR %vPythonInstallDir%\DLLs
mkdir %vPythonInstallDir%\DLLs

ECHO copying Files %vPythonBuildDir%\PCbuild\amd64\*.pyd to %vPythonInstallDir%\DLLs\
XCOPY /f /y %vPythonBuildDir%\PCbuild\amd64\*.pyd %vPythonInstallDir%\DLLs\

ECHO copying Files %vPythonBuildDir%\PCbuild\amd64\*.dll to %vPythonInstallDir%\DLLs\
XCOPY /f /y %vPythonBuildDir%\PCbuild\amd64\*.dll %vPythonInstallDir%\DLLs\

ECHO copying Files %vTclInstallDir%\bin\*.dll to %vPythonInstallDir%\DLLs\
XCOPY /f /y %vTclInstallDir%\bin\*.dll %vPythonInstallDir%\DLLs\

ECHO copying Files c:\pgbuild64\bin\libeay32.dll to %vPythonInstallDir%\DLLs\
XCOPY /f /y c:\pgbuild64\bin\libeay32.dll %vPythonInstallDir%\DLLs\

ECHO copying Files  c:\pgbuild64\bin\ssleay32.dll to %vPythonInstallDir%\DLLs\
XCOPY /f /y c:\pgbuild64\bin\ssleay32.dll %vPythonInstallDir%\DLLs\

ECHO copying Files %vPythonBuildDir%\PC\*.ico to %vPythonInstallDir%\DLLs\
XCOPY /f /y %vPythonBuildDir%\PC\*.ico %vPythonInstallDir%\DLLs\

ECHO making DIR %vPythonInstallDir%\tcl
mkdir %vPythonInstallDir%\tcl

ECHO copying Folders & Files %vTclInstallDir%\lib\* to %vPythonInstallDir%\tcl\
XCOPY /s /e /f /h %vTclInstallDir%\lib\* %vPythonInstallDir%\tcl\

ECHO making DIR %vPythonInstallDir%\tcl\include
mkdir %vPythonInstallDir%\tcl\include

ECHO copying Files %vTclInstallDir%\include\* to %vPythonInstallDir%\tcl\include\
XCOPY /s /e /f /h %vTclInstallDir%\include\* %vPythonInstallDir%\tcl\include\

SET PYTHONHOME=%vPythonInstallDir%
SET PYTHONPATH=%vPythonInstallDir%;%vPythonInstallDir%\Lib;%vPythonInstallDir%\DLLs
SET PATH=%PYTHONHOME%;%PYTHONPATH%;%PATH%

ECHO PYTHONHOME -------- %PYTHONHOME% 
ECHO PYTHONPATH -------- %PYTHONPATH%
ECHO PATH -------- %PATH%

ECHO Changing Directory to %vScriptsDir%\setuptools-30.2.0
CD %vScriptsDir%\setuptools-30.2.0
python setup.py install

ECHO Changing Directory to %vPythonInstallDir%\Scripts
CD %vPythonInstallDir%\Scripts
SET PATH=%vPythonInstallDir%\Scripts;D:\;%vPgBuildDir%\bin;%PATH%

REM Sometimes pip is not able to download due to network issues.
REM Hence we are tryings to hit pip URL for 5 time.

setlocal EnableDelayedExpansion
set /a "i = 1"
:ITERATOR
    if %i% leq 5 (
	echo ==========iteration !i! ==================
        %vPythonInstallDir%\Scripts\easy_install.exe pip
       IF !ERRORLEVEL! == 0 goto BREAK
        echo ====error level is !ERRORLEVEL!===========
        set /a "i = i + 1"
        goto :ITERATOR
    )
goto ERR_HANDLER

:BREAK

CD %vPythonInstallDir%\Scripts
SET LINK="/FORCE:MULTIPLE"
pip install psycopg2==2.6
pip install Flask
pip install Jinja2
pip install MarkupSafe
pip install Werkzeug
pip install itsdangerous
pip install Flask-Login
pip install Flask-Security
pip install Flask-WTF
pip install simplejson
rem pip install Pillow
pip install pytz
pip install sphinx "babel<2.0"
pip install cython

ECHO copying required dll's to %vPythonInstallDir%\Lib\site-packages\psycopg2

XCOPY /f /y %vOpenSSLDir%\bin\libeay32.dll %vPythonInstallDir%\Lib\site-packages\psycopg2
XCOPY /f /y %vOpenSSLDir%\bin\ssleay32.dll %vPythonInstallDir%\Lib\site-packages\psycopg2
XCOPY /f /y %vOpenSSLDir%\bin\libintl-8.dll %vPythonInstallDir%\Lib\site-packages\psycopg2
XCOPY /f /y %vOpenSSLDir%\bin\libiconv-2.dll %vPythonInstallDir%\Lib\site-packages\psycopg2
XCOPY /f /y %vPgBuildDir%\bin\libpq.dll %vPythonInstallDir%\Lib\site-packages\psycopg2

ECHO copying Pillow binaries to %vPythonInstallDir%
XCOPY /Y /E /Q  %vScriptsDir%\EnterpriseDB\LanguagePack\9.5\x64\Python-3.3\Lib\site-packages\* %vPythonInstallDir%\Lib\site-packages\
XCOPY /s /e /f /h %vScriptsDir%\EnterpriseDB\LanguagePack\9.5\x64\Python-3.3\Scripts\* %vPythonInstallDir%\Scripts\

pip list >%vPythonInstallDir%\pip_packages_list.txt

ECHO ------------------------
ECHO ----------Done----------

goto EXIT

:ERR_HANDLER
    ECHO Aborting build due to pip failed!
    endlocal
    exit /B 1
GOTO:EOF


:EXIT
    endlocal
    exit /B 0
