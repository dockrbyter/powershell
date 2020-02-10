<#
wlanProfilImport.ps1

Impoertiert WLAN-Profile
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$wlanProfil = "wlan.xml"             # Zu importierendes Profil 


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " @ Windows 10: ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n")
$stringimport1 = [System.String]::Concat("   Importiere WLAN-Profil [ ", $wlanProfil, " ] ")
$stringimport2 = [System.String]::Concat("   Import von WLAN-Profil [ ", $wlanProfil), " ] erledigt!"

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Importiere WLAN-Profil $wlanProfil"
Write-Host " "
Start-Sleep -Seconds 1.5

netsh wlan add profile filename="$PSScriptRoot\$wlanProfil" user=all    # user=all oder current

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Import von WLAN-Profil $wlanProfil"
Write-Host " "
Start-Sleep -Seconds 1.5