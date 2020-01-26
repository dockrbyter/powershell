<#
notebookhelperSO.ps1

Hilft Notebooks nach der Windowsinstallation nach Hause zu finden

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$neuerName = "NB02"                 # Gewuenschter Name

$loeschuser = "User12"                 # Zu loeschender user BSP "DummerUser4"
$userPWbearbeitung = "Admin"        # User dessen Passwort geaendert werden soll BSP "User13"

$wlanProfil1 = "wlan.xml"             # Zu importierendes Profil 1
$wlanProfil2 = "wlan.xml"             # Zu importierendes Profil 2
    $wlanDelay = "10"               # Zu wartende Zeit nach WLAN-Beitritt um auf Adaptnerneustart zu warten in Sekunden BSP "10"

$proxyserver = "10.10.10.10:8080"   # Proxy + Port BSP: "172.16.0.1:8080"

$domaintojoin = "domain.local"        # Domainname BSP: "pettingzoo.party"
    #$oupfad = "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"             # Der OU-Pfad (distinguishedName) BSP: "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"

$delay = "5"                       # Wartezeit nach Abschluss fuer Neustart (Script hat eigenes Delay von 5 Sekunden)


#--- Verarbeitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Phase 0 - Begruessung und Credentials

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "   -- Notebook Helper -- "
Write-Host " "
Write-Host " "
Write-Host " "
Start-Sleep -Milliseconds 500

Clear-Host
Write-Host " "
Write-Host "    HOST: $env:computername "
Write-Host " "
Write-Host " "
Write-Host "   Hey hey hey!"
Write-Host "   Hast du dich verlaufen, kleines Notebook?"
Write-Host "   Ich helfe dir nach Hause..."
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

Clear-Host
Write-Host " " 
Write-Host " "
Write-Host "   Domain Credentials benoetigt!"
Write-Host " "
Write-Host " " 

$domaincredential = Get-Credential

pause

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "        Neues Passwort"
Write-Host "        $userPWbearbeitung "
Write-Host "        benoetigt!"
Write-Host " "

$neuespw = read-host "Passwort $userPWbearbeitung" -asSecureString                  # WLAN Key 1


#--- Phase I - Name, User, WLAN1 und Updates -------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "        Phase 1"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Remove-LocalUser -Name $loeschuser                              # Ueberfluessiger User loeschen

$userX = Get-LocalUser -Name $userPWbearbeitung                 # Get-LocalUser binden
$userX | Set-LocalUser -Password $neuespw                       # Passwort fuer User aendern

Clear-Host
Write-Host " "
Write-Host " "
Write-Host " Ueberfluessinger User $loeschuser entfernt!"
Write-Host " Passwort fuer $userPWbearbeitung gesetzt!"
Write-Host " "
Start-Sleep -Milliseconds 500
Clear-Host 

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host " Benenne Computer $env:computername in $neuerName um..."
Write-Host " "
Start-Sleep -Milliseconds 500
Clear-Host

Rename-Computer -NewName $neuerName

    Clear-Host
    Write-Host " "
    Write-Host " "
    Write-Host " Erledigt... Trete WLAN1  $ssid1  bei..."
    Write-Host " "
    Start-Sleep -Milliseconds 500
    Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

netsh wlan add profile filename="$PSScriptRoot\$wlanProfil1" user=all                # WLAN join 1
Restart-NetAdapter
    
    Clear-Host
    Write-Host " "
    Write-Host " "
    Write-Host " WLAN1  $wlanProfil1  verbunden! Mache $wlanDelay Sek Pause... Lade dann Updates..."
    Write-Host " "
    Start-Sleep --Seconds $wlanDelay
    Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------    

Install-Module -Name PSWindowsUpdate –Force             # PowerShell Update-Modul installieren
Import-Module PSWindowsUpdate                           # PowerShell Update-Modul importieren

    Download-WindowsUpdate -ForceDownload               # Updates downloaden
    Install-WindowsUpdate -ForceInstall                 # Updates installieren

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Clear-Host
    Write-Host " "
    Write-Host " "
    Write-Host " Updates installiert! Entferne WLAN1  $wlanProfil1  ..."
    Write-Host " " 
    Start-Sleep -Milliseconds 500
    Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Netsh wlan delete profile $wlanProfil1                        # WLAN1 Profil loeschen

    Clear-Host
    Write-Host " "
    Write-Host " "
    Write-Host " WLAN1  $wlanProfil1  entfernt!"
    Write-Host " "
    Start-Sleep -Milliseconds 500
    Clear-Host

#--- Phase II - WLAN2, Proxy und Domainjoin -------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "        Phase 2"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

Clear-Host
Write-Host " "
Write-Host " "
Write-Host " Setze Proxy und trete WLAN2  $wlanProfil2  bei..."
Write-Host " "
Start-Sleep -Milliseconds 500
Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

netsh winhttp set proxy $proxyserver                    # Proxy setzen

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

netsh wlan add profile filename="$PSScriptRoot\$wlanProfil2" user=all                # WLAN join 2
Restart-NetAdapter

    Clear-Host
    Write-Host " "
    Write-Host " "
    Write-Host " Proxy gesetzt!"
    Write-Host " WLAN2  $wlanProfil2  verbunden! Mache $wlanDelay Sek Pause, "
    Write-Host " trete dann Domain $domaintojoin bei..."
    Write-Host " "
    Start-Sleep -Seconds $wlanDelay
    Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Add-Computer -DomainName $domaintojoin -Credential $domaincredential  # -OUPath $oupfad      # Domainjoin

    Clear-Host
    Write-Host " "
    Write-Host " "
    Write-Host " Domain  $domaintojoin  beigetreten!"
    Write-Host " "
    Start-Sleep -Milliseconds 500
    Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "    Alles Erledigt!"
Write-Host "    Das Notebook $env:computername ( $neuerName )"
Write-Host "    ist jetzt zuhause..."
Write-Host " "
Start-Sleep -Seconds 5
Clear-Host

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "   -- Notebook Helper --"
Write-Host " "
Start-Sleep -Milliseconds 300

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "   Neustart in $delay Sekunden"
Write-Host "       +5"
Write-Host " "
Start-Sleep -Seconds 1

Write-Host "   Neustart in $delay Sekunden"
Write-Host "       +4"
Write-Host " "
Start-Sleep -Seconds 1

Write-Host "   Neustart in $delay Sekunden"
Write-Host "       +3"
Write-Host " "
Start-Sleep -Seconds 1

Write-Host "   Neustart in $delay Sekunden"
Write-Host "       +2"
Write-Host " "
Start-Sleep -Seconds 1

Write-Host " Neustart in $delay Sekunden "
Write-Host "       +1"
Start-Sleep -Seconds 1

Write-Host " Neustart in $delay Sekunden "

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Restart-Computer -Wait Delay $delay -Force           # Neustart
