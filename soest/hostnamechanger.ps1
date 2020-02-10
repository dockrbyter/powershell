<#
hostnamechanger.ps1

    Aendert den Hostname

#>
#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " @ Windows 10: ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n")
$stringname = [System.String]::Concat("   Neuer Hostname: ", $neuerHostName, "`n", "`n", "   Rebooten zum Uebernehmen ;) ")

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Read-Host "   Neuer Hostname?" $neuerHostName

Rename-Computer -NewName $neuerHostName

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringname
Start-Sleep -Seconds 2

