
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

#Application pool setting for IIS
Import-Module WebAdministration
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

Write-Output "Finalsteps script complete!"