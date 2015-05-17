!include x64.nsh
!include WinVer.nsh
!include nsDialogs.nsh

SetCompressor lzma
Name "Windows BackupPC Rsync-Shadow Copy Client"
 
SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
XPStyle on

Var Dialog
Var UnameLabel
Var UnameText
Var UnameText_Entry
Var PasswordLabel
Var PasswordText
Var PasswordText_Entry

; The file to write
OutFile "backuppc-client.exe"

; The default installation directory
InstallDir C:\BackupPC

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages
PageEx license
   LicenseData license.txt
   LicenseForceSelection checkbox
PageExEnd
Page directory
Page custom RsyncSecretsPage RsyncSecretsSave
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------



; The stuff to install
Section "BackupPC rsync-vshadow client" ;No components page, name is not important

  ${If} ${AtMostWin2000}
    MessageBox MB_OK "Vshadow not supported on this version of Windows."
	Abort "Vshadow not supported on this version of Windows."
  ${EndIf}

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Delete obsolete files
  Delete cygcrypto-0.9.8.dll
  Delete cygintl-3.dll
  Delete cygminires.dll
  
  ; Put files there
  SetOverwrite off
  File part.cmd
  File rsyncd.conf
  SetOverwrite on
  File backuppc.cmd
  File dosdev.exe
  File pre-cmd.vbs
  File pre-exec.cmd
  File sleep.vbs
  File vsrsync.cmd
  File vss-setvar.cmd
  
  ${If} ${RunningX64}
   DetailPrint "Using 64-bit Cygwin"
   File /oname=cygwin1.dll cygwin1-x64.dll
   File /oname=cygiconv-2.dll cygiconv-2-x64.dll
   File /oname=cygz.dll cygz-x64.dll
   File /oname=rsync.exe rsync-x64.exe
  ${Else}
   DetailPrint "Using 32-bit Cygwin"
   File /oname=cygwin1.dll cygwin1-x86.dll
   File /oname=cygiconv-2.dll cygiconv-2-x86.dll
   File /oname=cygz.dll cygz-x86.dll
   File /oname=rsync.exe rsync-x86.exe
  ${EndIf}   

; Handle proper version of vshadow
  
  ${If} ${IsWinXP}
   DetailPrint "Windows XP vshadow"
   File /oname=vshadow.exe vshadow-xp-x86.exe
  ${ElseIf} ${IsWin2003}
   DetailPrint "Windows 2003 vshadow"
   File /oname=vshadow.exe vshadow-2003-x86.exe
  ${ElseIf} ${IsWin2008}
  ${OrIf} ${IsWinVista}
    ${If} ${RunningX64}
     DetailPrint "64-bit 2008/Vista vshadow"
	 File /oname=vshadow.exe vshadow-2008-x64.exe
    ${Else}
     DetailPrint "32-bit 2008/Vista vshadow"
	 File /oname=vshadow.exe vshadow-2008-x86.exe
    ${EndIf}
  ${ElseIf} ${IsWin2008R2}
  ${OrIf} ${AtLeastWin7}
    ${If} ${RunningX64}
	  DetailPrint "64-bit v3.0 vshadow"
	  File /oname=vshadow.exe vshadow-2008-r2-x64.exe
	${Else}
	  DetailPrint "32-bit v3.0 vshadow"
	  File /oname=vshadow.exe vshadow-2008-r2-x86.exe
	${EndIf}
  ${Else}
    MessageBox MB_OK "Cannot determine version of vshadow to use"
	Abort
  ${EndIf}

  DetailPrint "Adding rsync.exe to firewall exception list"
; Add an application to the firewall exception list - All Networks - All IP Version - Enabled
  SimpleFC::AddApplication "rsync (backuppc)" "$INSTDIR\rsync.exe" 1 2 "" 1
  Pop $0
  ${If} $0 == 1
    DetailPrint "Error adding rsync.exe to firewall exception list"
  ${Else}
    DetailPrint "rsync.exe added to firewall exception list"
  ${EndIf}
  
  DetailPrint "Making system pingable"
 
; Adds an ICMPv4 rule to allow incoming echo request messages (IcmpCodeAndType = 8:0)
  SimpleFC::AdvAddRule "Echo-Request (ICMPv4 incoming)" \
    "Allows incoming ICMP Echo messages." "1" "1" "1" "7" "1" "" \
    "8:0" "@PathToApplication,-10000" "" "" "" ""
  Pop $0
  ${If} $0 == 1
    DetailPrint "Error adding Echo-Request (ICMPv4 incoming) to firewall exception list"
  ${Else}
    DetailPrint "Echo-Request (ICMPv4 incoming) added to firewall exception list"
  ${EndIf}
  
  WriteUninstaller "uninstall.exe"
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BackupPC" \
                 "DisplayName" "BackupPC Client (rsync-vshadow-winexe)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BackupPC" \
                 "DisplayVersion" "1.3.1"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BackupPC" \
                 "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  
SectionEnd ; end the section

Section "Uninstall"
  
  ; Remove firewall exception
  SimpleFC::RemoveApplication  "$INSTDIR\rsync.exe"
  ${If} $0 == 1
    DetailPrint "Error removing rsync.exe from firewall exception list"
  ${Else}
    DetailPrint "rsync.exe removed from firewall exception list"
  ${EndIf}
  
  ; Remove files and uninstaller
  Delete $INSTDIR\backuppc.cmd
  Delete $INSTDIR\cygcrypto-0.9.8.dll
  Delete $INSTDIR\cygiconv-2.dll
  Delete $INSTDIR\cygintl-3.dll
  Delete $INSTDIR\cygminires.dll
  Delete $INSTDIR\cygwin1.dll
  Delete $INSTDIR\cygz.dll
  Delete $INSTDIR\dosdev.exe
  Delete $INSTDIR\part.cmd
  Delete $INSTDIR\pre-cmd.vbs
  Delete $INSTDIR\pre-exec.cmd
  Delete $INSTDIR\rsync.exe
  Delete $INSTDIR\rsyncd.conf
  Delete $INSTDIR\sleep.vbs
  Delete $INSTDIR\vsrsync.cmd
  Delete $INSTDIR\vss-setvar.cmd
  Delete $INSTDIR\example2.nsi
  Delete $INSTDIR\uninstall.exe
  Delete $INSTDIR\rsyncd.secrets
  Delete $INSTDIR\file.out
  Delete $INSTDIR\diagnostic.txt
  Delete $INSTDIR\vshadow.exe
  
  RMDir "$INSTDIR"
  
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BackupPC"

SectionEnd

Function RsyncSecretsPage
   SetOutPath $INSTDIR
   DetailPrint "rsyncd.secrets check"
   IfFileExists $INSTDIR\rsyncd.secrets +15
   nsDialogs::Create 1018
   Pop $Dialog
   ${If} $Dialog == error
	  Abort
   ${EndIf}
   ${NSD_CreateLabel} 0 12u 100% 12u "Enter rsync username:"
	Pop $UnameLabel
	${NSD_CreateText} 0 25u 100% 12u $UnameText_Entry
	Pop $UnameText
	${NSD_CreateLabel} 0 50u 100% 12u "Enter rsync password:"
	Pop $PasswordLabel
	${NSD_CreateText} 0 65u 100% 12u $PasswordText_Entry
	Pop $PasswordText
   nsDialogs::Show
FunctionEnd

Function RsyncSecretsSave

	${NSD_GetText} $UnameText $UnameText_Entry
	${NSD_GetText} $PasswordText $PasswordText_Entry
	
	IfFileExists $INSTDIR\rsyncd.secrets +11
	
	FileOpen $9 $INSTDIR\rsyncd.secrets w
	FileWrite $9 $UnameText_Entry
	FileWrite $9 :
	FileWrite $9 $PasswordText_Entry
	FileWrite $9 "$\r$\n"
	FileClose $9 
	
	DetailPrint "rsyncd.secrets created"
	
FunctionEnd

