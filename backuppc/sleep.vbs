Const Rsync = "C:\BackupPC\rsyncd.pid"
Const Flag = "C:\BackupPC\wake.up"

'
' Just sleep until the file "rsyncd.pid" appears
'

While DoesFileExist(Rsync)
   wscript.sleep 10000
Wend

'
' Now sleep until the file "wake.up" appears
'

While DoesFileExist(Flag)
   wscript.sleep 10000
Wend

Set fso = CreateObject("Scripting.FileSystemObject")
Set aFile = fso.GetFile(Flag)
aFile.Delete

'
' It's time to kill Rsync
'
Set fso = CreateObject("Scripting.FileSystemObject")
Set aReadFile = fso.OpenTextFile(Rsync, 1)
strContents = aReadFile.ReadLine
aReadFile.Close

Set objShell = CreateObject("WScript.Shell")
objShell.Run "taskkill /f /pid " & strContents, 0, true
'
' Wait for Rsync to let go
'
wscript.sleep 5000
'
' Delete PID file
'
If DoesFileExist(Rsync)=0 Then
   Set objShell = CreateObject("WScript.Shell")
   objShell.Run "cmd /c del C:\BackupPC\rsyncd.pid", 0, true
End If 

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
