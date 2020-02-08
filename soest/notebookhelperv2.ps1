<#
notebookhelperv2.ps1

Hilft Notebooks nach der Windowsinstallation nach Hause zu finden

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$neuerHostName = "NB09"                 # Gewuenschter Name

$loeschuser = "crapuser"                # Zu loeschender user BSP "DummerUser4"
$userPWbearbeitung = "Administrator"    # User dessen Passwort geaendert werden soll BSP "User13"

$wlanProfil1 = "WLAN-1.xml"             # Zu importierendes WLAN-Profil 1
$wlanProfil2 = "WLAN10004.xml"          # Zu importierendes WLAN-Profil 2
$wlanEntf = $wlanProfil1                # Zu loeschendes WLAN-Profil
    $wlanDelay = "10"                   # Die Zeit nach WLAN-Beitritt um auf Adaptnerneustart zu warten in Sekunden BSP "10"

$proxyserver = "101.102.103.104:16969"       # Proxy + Port BSP: "172.16.0.1:8080"
    $proxyDelay = "3"                   # Zu wartende Zeit nach Proxy-Anfrage in Sekunden BSP "5"

$domaintojoin = "powerpetting.party"    # Domainname BSP: "pettingzoo.party"
    #$oupfad = "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"             # Der OU-Pfad (distinguishedName) BSP: "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"


$scriptfilepath = $env:TEMP             # Ziel-Pfad des Scripts (Script wird auf den Host kopiert und entfernt) BSP: "C:\tmp"


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Phase 0 - Intro ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host "   -- Notebook Helper V2 -- "
Write-Host " "
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 3
Clear-Host


#--- Phase 0 - Vorbereitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$scriptdatei = $MyInvocation.MyCommand.Name                                                                         # Script-Variable zusammenbauen
$scriptquelle = [System.String]::Concat($PSScriptRoot, "\", $MyInvocation.MyCommand.Name)                           # Script-Variable zusammenbauen
$scripttarget = [System.String]::Concat($scriptfilepath, "\", $scriptdatei)                                        # Script-Variable zusammenbauen
$windom = (Get-WmiObject Win32_ComputerSystem).Domain                                                               # Domain ermitteln
$winbuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId      # Winbuild ermitteln

$scriptjobname = ($scriptdatei -replace ".{4}$")                                                                    # Dateiendung entfernen - Script
$wlanEntf = ($wlanEntf  -replace ".{4}$")                                                                           # Dateiendung entfernen - WLAN-Profil

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", $windom, " @ Windows 10:", $winbuild, " ]   ", (Get-Date), "`n", "  ", $MyInvocation.MyCommand.Name)
$stringatuser = [System.String]::Concat("   ", "@ ", $env:UserName, ":")

$stringusercred = [System.String]::Concat("   ", "Neues Passwort fuer ", $userPWbearbeitung, " benoetigt!")

$stringrename = [System.String]::Concat("   ", "System in ", $neuerHostName, " umbenannt")

$stringrb1 = [System.String]::Concat("   ", "Wir sind noch nicht fertig,", $env:computername, "!")
$stringrb2 = [System.String]::Concat("   ", "Du bist immer noch in  ", $windom)
$stringrb3 = [System.String]::Concat("   ", "und musst nach  ", $domaintojoin)
$stringrb4 = [System.String]::Concat("   ", $domaintojoin, "benoetigt!")

$stringwlan11 = [System.String]::Concat("   ", "Trete WLAN-1: ", $wlanProfil1, " bei, warte dann ", $wlanDelay, " Sekunden...")
$stringwlan12 = [System.String]::Concat("   ", "WLAN-1: ", $wlanProfil1, " beigetreten. Warte nun ", $wlanDelay, " Sekunden...")
$stringwlan21 = [System.String]::Concat("   ", "Trete WLAN-2: ", $wlanProfil2, " bei, warte dann ", $wlanDelay, " Sekunden...")
$stringwlan22 = [System.String]::Concat("   ", "WLAN-2: ", $wlanProfil2, " beigetreten. Warte nun ", $wlanDelay, " Sekunden...")
$stringwlanenft = [System.String]::Concat("   ", "Entferne WLAN: ", $wlanEntf, ", warte dann ", $wlanDelay, " Sekunden...")

$stringproxy = [System.String]::Concat("   ", "Setze Proxy-Server: ", $proxyserver , ", warte dann ", $proxyDelay, " Sekunden...")

$stringdomain11 = [System.String]::Concat("   ", "Trete Domain: ", $domaintojoin, " bei.")
$stringdomain12 = [System.String]::Concat("   ", "Domain: ", $domaintojoin, " beigetreten!")

$stringreboot = [System.String]::Concat("   ", "Neustart von ", $env:computername, " steht bevor!")

$stringerledgit1 = [System.String]::Concat("   ", "Das Notebook", $env:computername, " ist jetzt")
$stringerledgit2 = [System.String]::Concat("   ", "zuhause in der Domain", $domaintojoin, " angekommen.")
$stringerledgit3 = [System.String]::Concat("   ", "Ausserdem ist das WLAN-Profil", $wlanProfil2, " aktiv,")
$stringerledgit4 = [System.String]::Concat("   ", "Updates installier und der Proxy", $proxyserver, " eingestellt.")


#--- Phase 1 - Reboot-Check Script-File ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if (Test-Path $scripttarget -PathType leaf)
{   
    #--- Phase 5 - Nach dem Reboot --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host "   ...warte auf System..." -ForegroundColor Cyan
    Write-Host " "
    Write-Host " "
    Start-Sleep -Seconds 5
    
    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host "   ...da bin ich wieder!" -ForegroundColor Cyan
    Write-Host " "
    Write-Host " "
    Start-Sleep -Seconds 2
    
    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host $stringrb1
    Write-Host " "
    Write-Host $stringrb2
    Write-Host $stringrb3
    Write-Host " "
    Write-Host $stringatuser -ForegroundColor DarkRed
    Write-Host "    Als naechstes benoetige ich die Domain-Credentials."
    Write-Host "    Halte diese schonmal bereit."
    Write-Host " "
    Start-Sleep -Seconds 3
    Clear-Host

    
    #--- Phase 5 - Credentials ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " " 
    Write-Host " "
    Write-Host $stringatuser -ForegroundColor DarkRed
    Write-Host "   Credentials fuer"
    Write-Host $stringrb4
    Write-Host " "
    Write-Host " " 

    $domaincredential = Get-Credential
    Clear-Host
    
    
    #--- Phase 6 - Proxy ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host " "
    Write-Host $stringproxy
    Write-Host " "
    Start-Sleep -Seconds 1
    Clear-Host

        netsh winhttp set proxy $proxyserver                    # Proxy setzen
        Start-Sleep -Seconds $proxyDelay


    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "

    
    #--- Phase 6 - Domainjoin -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host " "
    Write-Host $stringdomain11
    Write-Host " "
    Start-Sleep -Seconds 1
    Clear-Host

        Add-Computer -DomainName $domaintojoin -Credential $domaincredential  # -OUPath $oupfad      # Domainjoin

    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host " "
    Write-Host $stringdomain12
    Write-Host " "
    Start-Sleep -Seconds 1
    Clear-Host

    
    #--- Phase 7 - Neustart 2 Vorbereitungen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



    
    #--- Phase 7 - Neustart 2 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host "   Alles erledigt!" -ForegroundColor Cyan
    Write-Host $stringerledgit1 -ForegroundColor Cyan
    Write-Host $stringerledgit2 -ForegroundColor Cyan
    Write-Host $stringerledgit3 -ForegroundColor Cyan
    Write-Host $stringerledgit4 -ForegroundColor Cyan
    Write-Host " "
    Write-Host " "
    Write-Host $stringatuser -ForegroundColor DarkRed
    Write-Host $stringreboot -ForegroundColor DarkRed
    Write-Host " "
    Write-Host " "
    Start-Sleep -Seconds 4
    
        Restart-Computer -Force           # Neustart
    
}


#--- Phase 1 - Begruessung ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host "   Hey hey hey!"  -ForegroundColor Cyan
Write-Host "   Hast du dich verlaufen, kleines Notebook?"  -ForegroundColor Cyan
Write-Host "   Ich helfe dir nach Hause..."  -ForegroundColor Cyan
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 3


#--- Phase 1 - Neues Passwort eingeben ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringatuser -ForegroundColor DarkRed
Write-Host $stringusercred
Write-Host " "
Write-Host " "

$neuespw = Read-Host "Passwort $userPWbearbeitung" -asSecureString                  # Neues User-PW

#--- Phase 2 - User entfernen -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Remove-LocalUser -Name $loeschuser                              # Ueberfluessiger User loeschen

    $userX = Get-LocalUser -Name $userPWbearbeitung                 # Get-LocalUser binden
    $userX | Set-LocalUser -Password $neuespw                       # Passwort fuer User aendern

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host " Ueberfluessinger User $loeschuser entfernt!"
Write-Host " Passwort fuer $userPWbearbeitung gesetzt!"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host 


#--- Phase 2 - System umbenennen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Rename-Computer -NewName $neuerHostName                         # Hostname aendern

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringrename
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host


#--- Phase 3 - WLAN join 1 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringwlan11
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

    netsh wlan add profile filename="$PSScriptRoot\$wlanProfil1" user=all                # WLAN join 1

Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringwlan12
Write-Host " "
Start-Sleep -Seconds $wlanDelay
Clear-Host


#--- Phase 3 - Updates --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Install-Module -Name PSWindowsUpdate -Force             # PowerShell Update-Modul installieren
Import-Module PSWindowsUpdate                           # PowerShell Update-Modul importieren

    Download-WindowsUpdate -ForceDownload               # Updates downloaden
    Install-WindowsUpdate -ForceInstall                 # Updates installieren

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host "   Updates installiert!"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host


#--- Phase 3 - WLAN 1 entfernen -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Netsh wlan delete profile $wlanProfil1 -Force                        # WLAN Profil loeschen

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringwlanenft
Write-Host " "
Start-Sleep -Seconds $wlanDelay
Clear-Host


#--- Phase 3 - WLAN join 2 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringwlan21
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

    netsh wlan add profile filename="$PSScriptRoot\$wlanProfil2" user=all                # WLAN join 2

Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringwlan22
Write-Host " "
Start-Sleep -Seconds $wlanDelay
Clear-Host


#--- Phase 4 - Neustart 1 Vorbereitungen --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host "   Bereite Neustart vor..."
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

    Copy-Item $scriptquelle -Destination $scripttarget                                      # Script auf Host kopieren

    $trigger = New-JobTrigger -AtLogOn -RandomDelay 00:00:05                                # Trigger fuer Task deffinieren
    Register-ScheduledJob -Trigger $trigger -FilePath $scripttarget -Name $scriptjobname    # Neue Task erstellen


#--- Phase 4 - Neustart 1 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringatuser -ForegroundColor DarkRed
Write-Host $stringreboot -ForegroundColor DarkRed
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 3

    Restart-Computer -Force           # Neustart

