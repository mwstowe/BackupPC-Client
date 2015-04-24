REM This file is used to map shadow drives to partitions
REM PART is a list of partitions to be shadowed, up to seven e.g.:
REM PART=C: E: F:
REM
REM MAP is a list of shadow drives corresponding to the partitions, e.g:
REM MAP=B: A: L: 
REM
REM rsyncd.conf will reference the shadow drives with the path /cygwin/B/ /cygwin/A/ and so on 
REM
SET PART=C:
SET MAP=B: