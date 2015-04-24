Const Flag = "C:\BackupPC\rsyncd.pid"
'
' Pid file shouldn't be there already
'
If DoesFileExist(Flag)=0 Then
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set aFile = fso.GetFile(Flag)
   aFile.Delete
End If
'
' Nor should "wake.up"
'
If DoesFileExist("C:\BackupPC\wake.up")=0 Then
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set aFile = fso.GetFile("C:\BackupPC\wake.up")
   aFile.Delete
End If

Set objShell = CreateObject("WScript.Shell")
objShell.Exec "cscript C:\BackupPC\sleep.vbs" 

Set objShell = CreateObject("WScript.Shell")
objShell.Exec "C:\BackupPC\backuppc.cmd > C:\BackupPC\file.out"

'
' Just sleep until the file "rsyncd.pid" appears
'

While DoesFileExist(Flag)
   wscript.sleep 10000
Wend


' functions

function DoesFileExist(FilePath)
Dim fso
	Set fso = CreateObject("Scripting.FileSystemObject")
	if not fso.FileExists(FilePath) then
		DoesFileExist = -1
	else
		DoesFileExist = 0
	end if
	Set fso = Nothing

end function