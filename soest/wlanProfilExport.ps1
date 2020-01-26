<#
wlanProfilExport.ps1

Exportiert alle WLAN-Profile mit Key
#>
#--- Verarbeitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host "   Eportiere WLAN-Profile mit Keys... "
Write-Host " "
Start-Sleep -Milliseconds 500


netsh wlan export profile key=clear folder=$PSScriptRoot
