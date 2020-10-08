<#
wlanProfilImport.ps1
.DESCRIPTION

    Impoertiert WLAN-Profile
    aus dem Scriptverzeinis

https://github.com/thelamescriptkiddiemax/soest
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$wlanProfil = "wlan.xml"             # Zu importierendes Profil 

$importuser = "all"                 # all oder current

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " @ Windows 10: ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n")
$stringimport1 = [System.String]::Concat("   Importiere WLAN-Profil [ ", $wlanProfil, " ] ", "`n")
$stringimport2 = [System.String]::Concat("   Import von WLAN-Profil [ ", $wlanProfil, " ] erledigt!", "`n")

$importprofil = "$PSScriptRoot\$wlanProfil"


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringimport1
Start-Sleep -Seconds 1.5

netsh wlan add profile filename=$importprofil user=$importuser

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringimport2
Start-Sleep -Seconds 1.5

