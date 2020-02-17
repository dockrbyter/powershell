<#
USBdriveKumpel.ps1
.DESCRIPTION

    Auf USB-Drive kopieren und ausfuehren :D
    Entfernt Problemchen vom Drive, die auftreten, wenn man es einfach rauszieht...
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")

$usbdletter = (get-location).Drive.Name
$usbdletter = [System.String]::Concat($usbdletter, ":")
$ubdrivesall = Get-WmiObject Win32_USBControllerDevice | ForEach-Object{[wmi]($_.Dependent)} | Where-Object {($_.Description -like '*mass*')} | Sort-Object Description,DeviceID | Format-Table Description,DeviceID


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $ubdrivesall
Write-Host "   OOOooooooohhhhh.... Hat Windows deinen Stick nicht mehr lieb? Warte, ich klaer das..."
Write-Host "   Druecke Enter um zu Beginnen"
Pause

Repair-Volume -FileSystemLabel $usbdletter -OfflineScanAndFix

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   ....alles wieder gut, war nur ein Missverstaendniss..."
Start-Sleep -Seconds 2

