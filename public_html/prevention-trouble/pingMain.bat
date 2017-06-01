@echo off
set chkhost=%1
set outdir=C:\chappy\study\network
ping -n 1 %chkhost% > %outdir%\\%chkhost%.txt
ping %chkhost% > %outdir%\\%chkhost%.txt
for /F "eol=; skip=10 tokens=3,6,9 delims=m " %%1 in (%outdir%\\%chkhost%.txt) do @echo %chkhost%,%time:~0,2%:%time:~3,2%:%time:~6.2%,%%i,%%j,%%k,%DATE% >> %outdir%\\ping_daily.txt
set chkhost=
set outdir=
