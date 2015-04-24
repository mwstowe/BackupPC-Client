# BackupPC-Client
Windows client and installer for BackupPC

To build, use NSIS version 3.0 or later, to create an installer that:
- Selects the proper version of "vshadow.exe" to match the Windows version
- Adds an exception to the firewall to allow "rsync.exe" to execute
- Copies the scripts and binaries to the hard drive
