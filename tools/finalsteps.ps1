
#Set Application pool permissions
$acl = Get-Acl C:\UniversalDashboard\UDDashboard
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS AppPool\UDDashboard", "ReadAndExecute", "Allow")
$acl.SetAccessRule($accessRule)
$acl | Set-Acl

#Set Application pool permissions
$acl = Get-Acl C:\UniversalDashboard\UDRestAPI
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS AppPool\UDRestAPI", "ReadAndExecute", "Allow")
$acl.SetAccessRule($accessRule)
$acl | Set-Acl

#Install ASP.NET Core hosting bundle - see https://docs.universaldashboard.io/webserver/running-dashboards/iis
Set-Location "C:\Temp"
$source = "https://download.visualstudio.microsoft.com/download/pr/ba001109-03c6-45ef-832c-c4dbfdb36e00/e3413f9e47e13f1e4b1b9cf2998bc613/dotnet-hosting-2.2.8-win.exe"
$destination = "C:\Temp\dotnet-hosting-2.2.8-win.exe"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($source, $destination)
Start-Process -FilePath $destination -Wait -ArgumentList '/Quiet'

#Application pool setting for IIS
Set-ItemProperty IIS:\AppPools\UDDashboard managedPipelineMode Integrated
Set-ItemProperty IIS:\AppPools\UDDashboard autoStart true
Set-ItemProperty IIS:\AppPools\UDRestAPI managedPipelineMode Integrated
Set-ItemProperty IIS:\AppPools\UDRestAPI startMode AlwaysRunning

<#
Check that PowerShell UniversalDashboard.Community is available with Get-Module UniversalDashboard.Community -ListAvaialble
if, not then install.  May need to also need to install nuget.
Find-Module UniversalDashboard.Community | Install-Module
#>

iisreset