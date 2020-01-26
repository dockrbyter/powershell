<#
wlanProfilImport.ps1

Impoertiert WLAN-Profile
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$wlanProfil = "wlan.xml"             # Zu importierendes Profil 

#--- Verarbeitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host "   Importiere WLAN-Profil $wlanProfil"
Write-Host " "
Start-Sleep -Milliseconds 500

netsh wlan add profile filename="$PSScriptRoot\$wlanProfil" user=all    # user=all oder current
