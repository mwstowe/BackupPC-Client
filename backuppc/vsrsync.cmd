REM @ECHO OFF
REM *****************************************************************
REM
REM VSRSYNC.CMD - Batch file template to start your rsync command (s).
REM
REM By Michael Stowe
REM *****************************************************************

call vss-setvar.cmd

cd \BackupPC

call part.cmd
SET CWRSYNCHOME=\BACKUPPC
SET CYGWIN=nontsec
SET CWOLDPATH=%PATH%
SET PATH=\BACKUPPC;%PATH%

FOR /F %%G IN ("%MAP%") DO (
	if "%SHADOW_DEVICE_1%" NEQ "" dosdev %%G %SHADOW_DEVICE_1%
	if "%SHADOW_DEVICE_2%" NEQ "" dosdev %%H %SHADOW_DEVICE_2%
	if "%SHADOW_DEVICE_3%" NEQ "" dosdev %%I %SHADOW_DEVICE_3%
	if "%SHADOW_DEVICE_4%" NEQ "" dosdev %%J %SHADOW_DEVICE_4%
	if "%SHADOW_DEVICE_5%" NEQ "" dosdev %%K %SHADOW_DEVICE_5%
	if "%SHADOW_DEVICE_6%" NEQ "" dosdev %%L %SHADOW_DEVICE_6%
	if "%SHADOW_DEVICE_7%" NEQ "" dosdev %%M %SHADOW_DEVICE_7%
)

REM Go into daemon mode, we'll kill it once we're done
rsync -v -v --daemon --config=rsyncd.conf --no-detach --log-file=diagnostic.txt

FOR /F %%G IN ("%MAP%") DO (
	if "%SHADOW_DEVICE_1%" NEQ "" dosdev -r -d %%G
	if "%SHADOW_DEVICE_2%" NEQ "" dosdev -r -d %%H
	if "%SHADOW_DEVICE_3%" NEQ "" dosdev -r -d %%I
	if "%SHADOW_DEVICE_4%" NEQ "" dosdev -r -d %%J
	if "%SHADOW_DEVICE_5%" NEQ "" dosdev -r -d %%K
	if "%SHADOW_DEVICE_6%" NEQ "" dosdev -r -d %%L
	if "%SHADOW_DEVICE_7%" NEQ "" dosdev -r -d %%M
)

