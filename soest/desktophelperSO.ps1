<#
notebookhelperSO.ps1

Hilft Desktops nach der Windowsinstallation nach Hause zu finden

#>

#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------



$loeschuser = "crapuser"                 # Zu loeschender user BSP "DummerUser4"
$userPWbearbeitung = "Administrator"        # User dessen Passwort geaendert werden soll BSP "User13"

$proxyserver = "10.10.10.10:8080"   # Proxy + Port BSP: "172.16.0.1:8080"

$domaintojoin = "superpaceinvader.solar"        # Domainname BSP: "pettingzoo.party"
    #$oupfad = "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"             # Der OU-Pfad (distinguishedName) BSP: "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"



#--- Verarbeitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Phase 0 - Begruessung und Credentials

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "   -- Desktop Helper -- "
Write-Host " "
Write-Host " "
Write-Host " "
Start-Sleep -Milliseconds 900

Clear-Host
Write-Host " "
Write-Host "    HOST: $env:computername "
Write-Host " "
Write-Host " "
Write-Host "   Hey hey hey!"
Write-Host "   Hast du dich verlaufen, kleiner Desktop"
Write-Host "   Ich helfe dir nach Hause..."
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 2
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

$neuespw = read-host "Passwort $userPWbearbeitung" -asSecureString                  # Neues User-Passwort


#--- Phase I - User und Updates -------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
Start-Sleep -Milliseconds 800
Clear-Host 


#--- Phase II - Proxy und Domainjoin -------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "        Phase 2"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host


#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Add-Computer -DomainName $domaintojoin -Credential $domaincredential  # -OUPath $oupfad      # Domainjoin

    Clear-Host
    Write-Host " "
    Write-Host " "
    Write-Host " Domain  $domaintojoin  beigetreten!"
    Write-Host " "
    Start-Sleep -Milliseconds 800
    Clear-Host


#------------------------------------------------------------------------------------------------------------------------------------------------------------------    
Clear-Host
Write-Host " "
Write-Host " "
Write-Host " Setze Proxy ..."
Write-Host " "
Start-Sleep -Milliseconds 800
Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

netsh winhttp set proxy $proxyserver                    # Proxy setzen
Clear-Host
    Write-Host " "
    Write-Host " "
    Write-Host " Proxy gesetzt!"
    Start-Sleep -Milliseconds 800
    Clear-Host


#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "    Alles Erledigt!"
Write-Host "    Der Desktop $env:computername "
Write-Host "    ist jetzt zuhause..."
Write-Host " "
Start-Sleep -Seconds 2
Clear-Host

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "   -- Desktop Helper --"
Write-Host " "
Start-Sleep -Milliseconds 900

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host "   Neustart des Systems in 5 Sekunden!"
Write-Host " "
Start-Sleep -Seconds 5

Restart-Computer -Force           # Neustart


