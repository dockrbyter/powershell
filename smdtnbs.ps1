<#
smdtnbs.ps1
.DESCRIPTION

    Stevenss MDT Notebook Script <3 <3 <3

    Erledigt Nacharbeiten fuer MDT-SRV-VM von Steven.
    Admin-Users anlegen, bzw. aktivieren, Passwoerter vergeben, ...
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$adminusername1 = "Wartung"
$adminusername2 = "Lehrer-GEE"


$scriptspeed = "2"                                                                  # Darstellungsdauer der Textausgaben in Sekunden                                            EX  2
$fmode = "x"                                                                        # Floating Mode (fuer Debugging)                                                            EX  x

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$scriptname = $MyInvocation.MyCommand.Name
& "$PSScriptRoot\smdtnbs-PWFILE.ps1"

$userlokadmin = "Administrator"
$stringuser1 = [System.String]::Concat("   ...erledigt! Erstelle User ", $adminusername1, " setze Passwort...")
$stringuser2 = [System.String]::Concat("   ...erledigt! Erstelle User ", $adminusername2, " setze Passwort...")

#--- Funktionen ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Scripthead
function scripthead
{

    # create stringhost
    $stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
    ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm"), "`n", "[ ", $scriptname, " ]", "`n","`n") 
    $stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

    # fmode
    if (!$fmode)
    {
        Clear-Host                                                                                                                                  # Clear Screen
    }

    Write-Host $stringhost -ForegroundColor Magenta

    Write-Host "   Stevenss MDT Notebook Script <3 <3 <3" -ForegroundColor Blue

    Write-Host "`n"

}

# Dauer Einblendungen
function scriptspeed ($scriptspeed)
{
    Start-Sleep -Seconds $scriptspeed                                                                                                               # display timeout
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead
Write-Host "   Aktiviere lokalen Administrator, setze Passwort..."
waittimer $scriptspeed

Get-LocalUser -Name $userlokadmin | Enable-LocalUser                                                                                                # Lokaler Admin aktivieren
$UserAccount = Get-LocalUser -Name $userlokadmin
$UserAccount | Set-LocalUser -Password $PWwlokaleradmin -PasswordNeverExpires                                                                       # Passwort von lokaler Admin setzen


scripthead
$stringuser1
waittimer $scriptspeed

New-LocalUser -Name $adminusername1 -Description "Nicht durch SIT verwaltet!" -Password $PWwartung -AccountNeverExpires                             # Zusaetzlicher Admin-User1 erstellen, Passwort vergeben
Add-LocalGroupMember -Group Administrators -Member $adminusername1                                                                                  # Zu Admin-Gruppe hinzufuegen

scripthead
$stringuser2
waittimer $scriptspeed

New-LocalUser -Name $adminusername2 -Description "Nicht durch SIT verwaltet!" -NoPassword -AccountNeverExpires -UserMayNotChangePassword | Set-LocalUser -PasswordNeverExpires $false   # Zusaetzlicher Admin-User2 erstellen, Passwort bei naechsten Login setzen
Add-LocalGroupMember -Group Administrators -Member $adminusername1                                                                                  # Zu Admin-Gruppe hinzufuegen

scripthead
Write-Host "   Alles erledigt! User angelegt, bzw. aktiviert und administrativer Gruppe hinzugefuegt."
waittimer $scriptspeed


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID       # Shell schliessen
