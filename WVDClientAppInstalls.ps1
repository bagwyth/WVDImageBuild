#Script to download and install software onto a golden image with Azure Image Builder

#Create folder to store build artifacts
New-Item -Path 'c:\buildArtifacts' -ItemType Directory -Force | Out-Null

#Create temp folder
New-Item -Path 'C:\temp' -ItemType Directory -Force | Out-Null

#Download and extract WVD Desktop Optimization Tool
Invoke-WebRequest -Uri 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/master.zip' -OutFile 'c:\buildArtifacts\Virtual-Desktop-Optimization-Tool.zip'
Expand-Archive -Path 'c:\buildArtifacts\Virtual-Desktop-Optimization-Tool.zip' -DestinationPath 'c:\buildArtifacts\' -Force

#Run the WVD Desktop Optimization tool
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
c:\buildArtifacts\Virtual-Desktop-Optimization-Tool-master\Win10_VirtualDesktop_Optimize.ps1 -WindowsVersion 2004

#Start sleep
Start-Sleep -Seconds 10

#Install VSCode
Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?Linkid=852157' -OutFile 'c:\temp\VScode.exe'
Invoke-Expression -Command 'c:\temp\VScode.exe /verysilent'

#Start sleep
Start-Sleep -Seconds 10

#Install Notepadplusplus
Invoke-WebRequest -Uri 'https://notepad-plus-plus.org/repository/7.x/7.7.1/npp.7.7.1.Installer.x64.exe' -OutFile 'c:\temp\notepadplusplus.exe'
Invoke-Expression -Command 'c:\temp\notepadplusplus.exe /S'

#Start sleep
Start-Sleep -Seconds 10

#Install FSLogix
Invoke-WebRequest -Uri 'https://aka.ms/fslogix_download' -OutFile 'c:\temp\fslogix.zip'
Start-Sleep -Seconds 10
Expand-Archive -Path 'C:\temp\fslogix.zip' -DestinationPath 'C:\temp\fslogix\'  -Force
Invoke-Expression -Command 'C:\temp\fslogix\x64\Release\FSLogixAppsSetup.exe /install /quiet /norestart'

#Start sleep
Start-Sleep -Seconds 10

#Install Teams Machine mode
New-Item -Path 'HKLM:\SOFTWARE\Citrix\PortICA' -Force | Out-Null
Invoke-WebRequest -Uri 'https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&download=true&managedInstaller=true&arch=x64' -OutFile 'c:\temp\Teams.msi'
Invoke-Expression -Command 'msiexec /i C:\temp\Teams.msi /quiet /l*v C:\temp\teamsinstall.log ALLUSER=1'
Start-Sleep -Seconds 30
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32 -Name Teams -PropertyType Binary -Value ([byte[]](0x01,0x00,0x00,0x00,0x1a,0x19,0xc3,0xb9,0x62,0x69,0xd5,0x01)) -Force
