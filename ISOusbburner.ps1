<#
ISOusbburner.ps1
.DESCRIPTION

    Burnt ISOs auf USB-Sticks
    LEGACY

https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " @ Windows 10: ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n")

$stringhallo = [System.String]::Concat("   Hallo ", $env:UserName, "!", "`n")

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringhallo
Write-Host " "
Start-Sleep -Seconds 2

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Wir basteln Dir einen LEGACY USB-Stick :D :D :D"
Write-Host " "
Start-Sleep -Seconds 2

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Read-Host "   Zu welchem Buchstaben ist dein Stick gemapt? (BSP E:)" $usbstick

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Read-Host "   Wo liegt die ISO? (BSP D:\ISOs\superfun.iso)" $isoimage


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Format-Volume -FileSystem Fat32 -DriveLetter $usbstick -Force
bootsect.exe /mbr $usbstick

xcopy ($isoimage +'\') ($usbstick + '\') /e

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Erledigt!"
Write-Host " "
Start-Sleep -Seconds 2

