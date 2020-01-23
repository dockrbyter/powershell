<#
notebookhelperSO.ps1

Hilft Notebooks nach der Windowsinstallation nach Hause zu finden

#>
#--- Variablen -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

$neuerName = "NB01"                 # Gewuenschter Name

$ssid1 = "ssid1"                    # SSID 1
$ssid2 = "ssid2"                    # SSID 2

$domaintojoin = "domain.tld"        # Domainname BSP: "pettingzoo.party"
    $oupfad = "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"             # Der OU-Pfad (distinguishedName) BSP: "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"

$delay = "10"                       # Wartezeit nach Abschluss fuer Neustart
    

#--- Verarbeitung ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Phase 0 - Begruessung und Credentials

Clear-Host
Write-Host " "
Write-Host "   -->> Notebook Helper <<--"
Write-Host " "
Start-Sleep -Milliseconds 500

Clear-Host
Write-Host " "
Write-Host "   Hey hey hey!"
Write-Host "   Hast du dich verlaufen, kleines Notebook?"
Write-Host "   Ich helfe dir nach Hause..."
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

Clear-Host
Write-Host " "
Write-Host "   Domain Credentials benoetigt!"
Write-Host " "

$domaincredential = Get-Credential

Clear-Host
Write-Host " "
Write-Host "        WLAN-Key fuer SSID $ssid1 benoetigt!"
Write-Host " "

$key1 = read-host "WLAN Key 1" -asSecureString                  # WLAN Key 1

Clear-Host
Write-Host " "
Write-Host "        WLAN-Key fuer SSID $ssid2 benoetigt!"
Write-Host " "

$key2 = read-host "WLAN Key 2" -asSecureString                  # WLAN Key 2

# Phase I - Name, WLAN1 und Updates

Clear-Host
Write-Host " "
Write-Host "        Phase 1"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

Clear-Host
Write-Host " "
Write-Host " Benenne Computer $env:computername in $neuerName um..."
Start-Sleep -Milliseconds 500
Clear-Host

Rename-Computer -NewName $neuerName

    Clear-Host
    Write-Host " "
    Write-Host " Erledigt... Trete WLAN1 >>> $ssid1 <<< bei..."
    Start-Sleep -Milliseconds 500
    Clear-Host

netsh wlan connect ssid=$ssid1 key=$key1                # WLAN join 1
    
    Clear-Host    
    Write-Host " "
    Write-Host " WLAN1 >>> $ssid1 <<< verbunden! Lade Updates..."
    Start-Sleep -Milliseconds 500
    Clear-Host

Install-Module -Name PSWindowsUpdate –Force             # PowerShell Update-Modul installieren
Import-Module PSWindowsUpdate                           # PowerShell Update-Modul importieren

    Download-WindowsUpdate -ForceDownload               # Updates downloaden
    Install-WindowsUpdate -ForceInstall                 # Updates installieren

    Clear-Host
    Write-Host " "
    Write-Host " Updates installiert! Entferne WLAN1 >>> $ssid1 <<< ..."
    Start-Sleep -Milliseconds 500
    Clear-Host


Netsh wlan delete profile $ssid1                        # WLAN Profil loeschen

    Clear-Host
    Write-Host " "
    Write-Host " WLAN1 >>> $ssid1 <<< entfernt!"
    Start-Sleep -Milliseconds 500
    Clear-Host

# Phase II - WLAN2 und Domainjoin

Clear-Host
Write-Host " "
Write-Host "        Phase 2"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

netsh wlan connect ssid=$ssid2 key=$key2                # WLAN join 2

    Clear-Host
    Write-Host " "
    Write-Host " WLAN2 >>> $ssid2 <<< verbunden! Trete Domain bei..."
    Start-Sleep -Milliseconds 500
    Clear-Host

Add-Computer -DomainName $domaintojoin -OUPath $oupfad -Credential $domaincredential        # Domainjoin

    Clear-Host
    Write-Host " "
    Write-Host " Domain >>> $domaintojoin <<< beigetreten!"
    Start-Sleep -Milliseconds 500
    Clear-Host

Clear-Host
Write-Host " "
Write-Host "    Alles Erledigt!"
Write-Host "    Das Notebook $env:computername ist jetzt zuhause..."
Start-Sleep -Seconds 3
Clear-Host

Clear-Host
Write-Host " "
Write-Host "   -->> Notebook Helper <<--"
Write-Host " "
Start-Sleep -Milliseconds 300

Clear-Host
Write-Host " "
Write-Host "   Neustart in $delay Sekunden"
Write-Host " "
Start-Sleep -Seconds 5

Restart-Computer -Delay $delay -Force           # Neustart nach Delay

