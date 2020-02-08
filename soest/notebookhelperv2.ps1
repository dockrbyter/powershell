<#
notebookhelperv2.ps1

Hilft Notebooks nach der Windowsinstallation nach Hause zu finden

    Loescht einen User, vergibt ein neues Passwort fuer einen anderen Userbenennt das System um, tritt einem ersten WLAN bei um Updates zu installieren, 
    loescht dieses dann wieder um dem finalen WLAN beizutreten, legt Proxy-Server fest und tritt der Domain bei. In diesem Vorgang wird das System zwei mal neugestartet.
    Dabei kopiert sich das Script selbst nach Temp und legt eine geplante Task an, die das Script nach dem Einloggen wieder startet.
    Wenn das Script mit seinen Aufgaben fertig ist, entfernt es sich und die geplante Task wieder vom System. 

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$neuerHostName = "NB09"                 # Gewuenschter Name

$loeschuser = "crapuser"                # Zu loeschender user BSP "DummerUser4"
$userPWbearbeitung = "Administrator"    # User dessen Passwort geaendert werden soll BSP "User13"

$wlanProfil1 = "WLAN-1.xml"             # Zu importierendes WLAN-Profil 1
$wlanProfil2 = "WLAN10004.xml"          # Zu importierendes WLAN-Profil 2
$wlanEntf = $wlanProfil1                # Zu loeschendes WLAN-Profil
    $wlanDelay = "10"                   # Die Zeit nach WLAN-Beitritt um auf Adaptnerneustart zu warten in Sekunden BSP "10"

$proxyserver = "101.102.103.104:16969"  # Proxy + Port BSP: "172.16.0.1:8080"
    $proxyDelay = "3"                   # Zu wartende Zeit nach Proxy-Anfrage in Sekunden BSP "5"

$domaintojoin = "powerpetting.party"    # Domainname BSP: "pettingzoo.party"
    #$oupfad = "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"             # Der OU-Pfad (distinguishedName) BSP: "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Phase 0 - Intro ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host "  _______          __        ___.                  __       ___ ___         .__                        ____   ____________   " -ForegroundColor Cyan
Write-Host "  \      \   _____/  |_  ____\_ |__   ____   ____ |  | __  /   |   \   ____ |  | ______   ___________  \   \ /   /\_____  \  " -ForegroundColor Cyan
Write-Host "  /   |   \ /  _ \   __\/ __ \| __ \ /  _ \ /  _ \|  |/ / /    ~    \_/ __ \|  | \____ \_/ __ \_  __ \  \   Y   /  /  ____/  " -ForegroundColor Cyan
Write-Host " /    |    (  <_> )  | \  ___/| \_\ (  <_> |  <_> )    <  \    Y    /\  ___/|  |_|  |_> >  ___/|  | \/   \     /  /       \  " -ForegroundColor Cyan
Write-Host " \____|__  /\____/|__|  \___  >___  /\____/ \____/|__|_ \  \___|_  /  \___  >____/   __/ \___  >__|       \___/   \_______ \ " -ForegroundColor Cyan
Write-Host "         \/                 \/    \/                   \/        \/       \/     |__|        \/                           \/ " -ForegroundColor Cyan
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 3
Clear-Host


#--- Phase 0 - Vorbereitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$scriptfilepath = $env:TEMP                                                                                         # Script-Variable zusammenbauen
$scriptdatei = $MyInvocation.MyCommand.Name                                                                         # Script-Variable zusammenbauen
$scriptquelle = [System.String]::Concat($PSScriptRoot, "\", $MyInvocation.MyCommand.Name)                           # Script-Variable zusammenbauen
$scripttarget = [System.String]::Concat($scriptfilepath, "\", $scriptdatei)                                         # Script-Variable zusammenbauen
$windom = (Get-WmiObject Win32_ComputerSystem).Domain                                                               # Domain ermitteln
$winbuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId      # Winbuild ermitteln

$schedaction = New-ScheduledTaskAction –Execute "$pshome\powershell.exe" -Argument  "$scripttarget; quit"           # Action fuer geplante Task
$schedsettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
$schedtrigger = New-JobTrigger -Once -AtLogOn -RandomDelay 00:00:05

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
$stringwlanenft1 = [System.String]::Concat("   ", "Entferne WLAN: ", $wlanEntf, ", warte dann ", $wlanDelay, " Sekunden...")
$stringwlanenft2 = [System.String]::Concat("   ", $wlanEntf, ", entfernt! Warte nun ", $wlanDelay, " Sekunden...")
$stringproxy = [System.String]::Concat("   ", "Setze Proxy-Server: ", $proxyserver , ", warte dann ", $proxyDelay, " Sekunden...")
$stringdomain11 = [System.String]::Concat("   ", "Trete Domain: ", $domaintojoin, " bei.")
$stringdomain12 = [System.String]::Concat("   ", "Domain: ", $domaintojoin, " beigetreten!")
$stringreboot = [System.String]::Concat("   ", "Neustart von ", $env:computername, " steht bevor!")
$stringerledgit1 = [System.String]::Concat("   ", "Das Notebook", $env:computername, " ist jetzt")
$stringerledgit2 = [System.String]::Concat("   ", "zuhause in der Domain", $domaintojoin, " angekommen.")
$stringerledgit3 = [System.String]::Concat("   ", "Ausserdem ist das WLAN-Profil", $wlanProfil2, " aktiv,")
$stringerledgit4 = [System.String]::Concat("   ", "Updates installier und der Proxy", $proxyserver, " eingestellt.")


#--- Phase 1 - Reboot-Check Script-File ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if (Test-Path $scripttarget -PathType leaf)     # Wenn Script in Temp vorahnden, dann...
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

    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host "   Zeit zum Aufraeumen..." -ForegroundColor Cyan
    Write-Host "   EXISTENCE IS PAIN :D" -ForegroundColor Cyan
    Write-Host " "
    Write-Host " "
    Write-Host "   Loesche mich selbst vom System..."
    Write-Host " "
    Start-Sleep -Seconds 1

        Unregister-ScheduledTask -TaskName $scriptjobname -Confirm:$false       # Geplante Task loeschen

        Remove-Item -Path $MyInvocation.MyCommand.Source                        # Script Selbstzerstoerung
    
    Clear-Host
    Write-Host " "
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host " "
    Write-Host " "
    Write-Host "   ...tat auch fast nicht weh..." -ForegroundColor Cyan
    Write-Host " "
    Write-Host " "
    Write-Host "   Script-Daten entfernt"
    Write-Host " "
    Start-Sleep -Seconds 1

    
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
Write-Host "   Hey hey hey!" -ForegroundColor Cyan
Write-Host "   Hast du dich verlaufen, kleines Notebook?" -ForegroundColor Cyan
Write-Host "   Ich helfe dir nach Hause..." -ForegroundColor Cyan
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 3


#--- Phase 1 - Credentials ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringatuser -ForegroundColor DarkRed
Write-Host "   Ich muss das System spaeter neustarten und dann weiter machen."
Write-Host "   Dafuer benoetige ich die Credentials des aktuellen Benutzers."
Write-Host " "
Write-Host " "

    $msg = "Credentials fuer geplante Task eingeben" 
    $schedcredential = $Host.UI.PromptForCredential("Geplante Task",$msg,"$env:userdomain\$env:username",$env:userdomain)

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host "   Gut gemacht!" -ForegroundColor Cyan
Write-Host "   Ab jetzt komme ich erstmal allein klar..." -ForegroundColor Cyan
Write-Host " "
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

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

Install-Module -Name PSWindowsUpdate -Force                 # PowerShell Update-Modul installieren
Import-Module PSWindowsUpdate                               # PowerShell Update-Modul importieren

    Download-WindowsUpdate -ForceDownload -Confirm:$false   # Updates downloaden
    Install-WindowsUpdate -ForceInstall -Confirm:$false     # Updates installieren

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

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringwlanenft1
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

    Netsh wlan delete profile $wlanProfil1 -Force           # WLAN Profil loeschen

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host $stringwlanenft2
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

    Copy-Item $scriptquelle -Destination $scripttarget              # Script auf Host kopieren

    $scheduser = $schedcredential.UserName                          # Task-User Variable
    $schedpw = $schedcredential.GetNetworkCredential().Password     # Task-Passwort Variable
   
    Register-ScheduledTask -TaskName $scriptjobname -Action $schedaction -Trigger $schedtrigger -RunLevel Highest -User $scheduser -Password $schedpw -Settings $schedsettings    # Neue Task erstellen

Clear-Host
Write-Host " "
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Write-Host " "
Write-Host " "
Write-Host "   Wir sehen uns gleich wieder..." -ForegroundColor Cyan
Write-Host " "
Write-Host " "
Write-Host "   Vorbereitungen abgeschlossen."
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host


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

