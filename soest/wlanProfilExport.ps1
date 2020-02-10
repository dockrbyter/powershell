<#
wlanProfilExport.ps1

    Exportiert alle WLAN-Profile mit Key

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$exportziel = $PSScriptRoot     # Wohin sollen die Profile exportiert werden? BSP C:\export\


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " @ Windows 10: ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n")
$stringexport1 = [System.String]::Concat("   Eportiere WLAN-Profile mit Keys nach:", "`n", "     --- ", $exportziel, " ---", "`n", "`n")
$stringexport2 = [System.String]::Concat("   WLAN-Profile nach:", "`n", "     --- ", $exportziel, " ---", "`n", "   exportiert!", "`n")


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringexport1
Start-Sleep -Seconds 1.5

netsh wlan export profile key=clear folder=$exportziel

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringexport2
Start-Sleep -Seconds 1.5

