#
notebookhelperv2.ps1

Hilft Notebooks nach der Windowsinstallation nach Hause zu finden

#>

#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$neuerName = "NB09"                 # Gewuenschter Name

$loeschuser = "crapuser"                 # Zu loeschender user BSP "DummerUser4"
$userPWbearbeitung = "Administrator"        # User dessen Passwort geaendert werden soll BSP "User13"

$wlanProfil1 = "WLAN-1.xml"             # Zu importierendes Profil 1
$wlanProfil2 = "WLAN10004.xml"             # Zu importierendes Profil 2
    $wlanDelay = "10"               # Zu wartende Zeit nach WLAN-Beitritt um auf Adaptnerneustart zu warten in Sekunden BSP "10"

$proxyserver = "10.10.10.10:8080"   # Proxy + Port BSP: "172.16.0.1:8080"

$domaintojoin = "powerpetting.party"        # Domainname BSP: "pettingzoo.party"
    #$oupfad = "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"             # Der OU-Pfad (distinguishedName) BSP: "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"




#--- Verarbeitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Phase 0 - Begruessung und Credentials

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "   -- Notebook Helper V2 -- "
Write-Host " "
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 2

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
Start-Sleep -Seconds 3
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

$neuespw = read-host "Passwort $userPWbearbeitung" -asSecureString                  # Neues User-PW