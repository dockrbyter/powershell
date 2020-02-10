<#
netsharestarter.ps1

Original:
https://support.microsoft.com/de-de/help/4471218/mapped-network-drive-may-fail-to-reconnect-in-windows-10-version-1809

    - Script angeeinetem Ort speichern
    - Geplante Task erstellen
        - Benutzer oder Gruppe auswaehlen BSP LocalComputer\Users
        - Neuer Trigger: Beim Anmelden
        - Aktion: Programm starten
            * Powershell.exe
            * Argumente: -windowsstyle hidden -command .\netsharestarter.ps1
            * Starten in: Speicherort des Scripts
        * Nur starten wenn folgende Netzwerkverbindung verfuegbar ist: Beliebige NIC 

#>
#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$i=3
while($True){
    $error.clear()
    $MappedDrives = Get-SmbMapping |where -property Status -Value Unavailable -EQ | select LocalPath,RemotePath
    foreach( $MappedDrive in $MappedDrives)
    {
        try {
            New-SmbMapping -LocalPath $MappedDrive.LocalPath -RemotePath $MappedDrive.RemotePath -Persistent $True
        } catch {
            Write-Host "There was an error mapping $MappedDrive.RemotePath to $MappedDrive.LocalPath"
        }
    }
    $i = $i - 1
    if($error.Count -eq 0 -Or $i -eq 0) {break}

    Start-Sleep -Seconds 30

}