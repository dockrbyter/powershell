<#
vernunvt.ps1
.DESCRIPTION

    VEReinfachtesNUtzerNachbearbeitungs&VerwaltungsTool

    Verinfachte AD-Oberflaeche zur Verwaltung
    von Benutzern

    - User aus Vorlage erstellen
    - Vorhandenen User kopieren
    - Passwort aendern
    - Benutzer loeschen
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$domainlokalname = "powerpetting"       # Name der Domain BSP: "domain"
$domainlokalsuffix = "party"            # Suffix der Domain BSP "local"
$lokalerdcname = "Uriel"                # Hostname des lokalen Domaincontrollers

$ougruppe1 = "thralls"                  # Namde der zu verwaltenden OU-Group 1
$ougruppe1vorlage = "thrallblanko"      # Vorlageprofil der OU-Group 1, aus dem neue User generiert werden sollen

$ougruppe2 = "minions"                  # Namde der zu verwaltenden OU-Group 2
$ougruppe2vorlage  = "minionsblanko"    # Vorlageprofil der OU-Group 2, aus dem neue User generiert werden sollen


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringbegruessung = [System.String]::Concat($env:UserName, ", probiers mal mit")
$stringverbindungsaufbau = [System.String]::Concat("  Baue Verbindung zu ", $lokalerdcname, " auf... `n  Bitte Anmelden")
$stringmenuad1 = [System.String]::Concat("     Taste 1 fuer Bearbeitung von ", $ougruppe1)
$stringmenuad2 = [System.String]::Concat("     Taste 2 fuer Bearbeitung von ", $ougruppe2)
$menugroupactive1 = [System.String]::Concat("  Taste 1 ---- Erstellen eines neuen Benutzers aus Standardvorlage fuer ", $ougruppeactive)
$menugroupactive2 = [System.String]::Concat("  Taste 2 ---- Kopieren eines vorhandenen Benutzers der Gruppe ", $ougruppeactive)
$menugroupactive3 = [System.String]::Concat("  Taste 3 ---- Aendern des Passwortes eines Benutzers der Gruppe ", $ougruppeactive)
$menugroupactive4 = [System.String]::Concat("  Taste 4 ---- Loeschen eines Benutzers der Gruppe ", $ougruppeactive)

$dcsessionname = "vernunftsession"              # PSSession Name

$Host.UI.RawUI.BackgroundColor = 'Magenta'      # Script Hintergrundfarbe
$Host.UI.RawUI.ForegroundColor = 'Yellow'       # Script Textfarbe


#--- Funktionen ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Show-MenuAD
{
    param ([string]$Title = "     Hauptmenu")
     
    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $Title -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host $stringmenuad1
    Write-Host $stringmenuad2
    Write-Host "     Taste Q zum Verbindung trennen und Beenden"
    Write-Host "`n------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function menugroupactive ($ougruppeactive) {

    do{
        Clear-Host
        Write-Host $stringhost -ForegroundColor Red
        Write-Host "                                                 __    " -ForegroundColor White
        Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
        Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
        Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
        Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
        Write-Host "             \/           \/           \/              " -ForegroundColor White
        Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
        Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
        Write-Host $ougruppeactive -ForegroundColor Blue
        Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
        Write-Host $menugroupactive1
        Write-Host $menugroupactive2
        Write-Host $menugroupactive3
        Write-Host $menugroupactive4
        Write-Host "  Taste Q ---- Zurueck zum Hauptmenu `n"
        Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan

        $input = Read-Host "Aufgabe?"
        switch ($input)
        {

           1 { adusercreate $ougruppeactive }       # Aktion Taste 1 - Erstellen eines neuen Benutzers
           2 { adusercopy $ougruppeactive }         # Aktion Taste 2 - Kopieren eines vorhandenen Benutzers
           3 { aduserpwchange $ougruppeactive }     # Aktion Taste 3 - Aendern des Passwortes eines Benutzers
           4 { aduserkill $ougruppeactive }         # Aktion Taste 4 - Loeschen eines Benutzers
    
        }
    }
    until ($input -eq 'q') 

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function adusercreate ($ougruppeactive) {
    
    if ($ougruppeactive = $ougruppe1 ) {
        $ougruppevorlactive = $ougruppe1vorlage
    }
    else {
        $ougruppevorlactive = $ougruppe2vorlage
    }

    $uservorlage = Get-AdUser $ougruppevorlactive -Properties *

    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $ougruppeactive -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    $neueruserNAME = Read-Host "`n   Vor- und Nachname des neuen Benutzers eingeben (BSP Maximilian Mustermeister)`n"

    New-ADUser -Name $neueruserNAME -Instance $uservorlage
    $stringusererstellt = [System.String]::Concat("  Neuer Benutzer ", $neueruserNAME, "`n  nach Vorlage ", $ougruppevorlactive, " erstellt!")

    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $ougruppeactive -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host $stringusererstellt
    Start-Sleep -Seconds 1.5

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function adusercopy ($ougruppeactive) {
    
    if ($ougruppeactive = $ougruppe1 ) {
        $ougruppevorlactive = $ougruppe1vorlage
    }
    else {
        $ougruppevorlactive = $ougruppe2vorlage
    }

    $oupfad = [System.String]::Concat("ou=", $ougruppevorlactive, ",dc=", $domainlokalname, ",dc=$domainlokalsuffix")
    $alleaduseringruppe = Get-ADUser -Filter * -SearchBase $oupfad | Select-object DistinguishedName


    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $ougruppeactive -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host $alleaduseringruppe -ForegroundColor White
    
    $aduseroriginal = Read-Host "`n   Welcher Benutzer soll kopiert werden?`n"                                                  # Neuer User Vorlage abfagen
    $neueruserNAME = Read-Host "`n   Vor- und Nachname des neuen Benutzers eingeben (BSP Maximilian Mustermeister)`n"           # Neuer User Name abfragen
    $neueruserpw = read-host "Passwort fuer $neueruserNAME `n" -asSecureString                                                  # Neuer User Passwort abfragen

    $uservorlage = Get-AdUser $aduseroriginal -Properties *                                                                     # Vorlage einlesen
    New-ADUser -Name $neueruserNAME -Instance $uservorlage                                                                      # Neuen User aus Vorlage erstellen
    Get-AdUser-Name $neueruserNAME | Set-ADAccountPassword -NewPassword $neueruserpw                                            # Neues Passwort fuer erstellten User vergeben

    $stringusererstellt = [System.String]::Concat("  Neuer Benutzer ", $neueruserNAME, "`n  nach Vorlage ", $aduseroriginal, " erstellt!")

    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $ougruppeactive -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host $stringusererstellt
    Start-Sleep -Seconds 1.5

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function aduserpwchange ($ougruppeactive) {
    
    if ($ougruppeactive = $ougruppe1 ) {
        $ougruppevorlactive = $ougruppe1vorlage
    }
    else {
        $ougruppevorlactive = $ougruppe2vorlage
    }

    $oupfad = [System.String]::Concat("ou=", $ougruppevorlactive, ",dc=", $domainlokalname, ",dc=$domainlokalsuffix")
    $alleaduseringruppe = Get-ADUser -Filter * -SearchBase $oupfad | Select-object DistinguishedName


    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $ougruppeactive -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host $alleaduseringruppe
    
    $aduserpwchange = Read-Host "`n   Wessen Passwort soll geaendert werden?`n"                                                 # User dessen Passwort geaendert werden soll auswaehlen
    $aduserpwchangepw = read-host "Passwort fuer $neueruserNAME `n" -asSecureString                                             # Neues User-Passwort abfragen

    Get-AdUser-Name $aduserpwchange | Set-ADAccountPassword -NewPassword $aduserpwchangepw                                      # Passwort aendern

    $stringpwchange = [System.String]::Concat("  Passwort von ", $neueruserNAME, " geaendert!")

    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $ougruppeactive -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host $stringpwchange
    Start-Sleep -Seconds 1.5

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function aduserkill ($ougruppeactive) {
    
    if ($ougruppeactive = $ougruppe1 ) {
        $ougruppevorlactive = $ougruppe1vorlage
    }
    else {
        $ougruppevorlactive = $ougruppe2vorlage
    }

    $oupfad = [System.String]::Concat("ou=", $ougruppevorlactive, ",dc=", $domainlokalname, ",dc=$domainlokalsuffix")
    $alleaduseringruppe = Get-ADUser -Filter * -SearchBase $oupfad | Select-object DistinguishedName


    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $ougruppeactive -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host $alleaduseringruppe
    
    $aduserrokill = Read-Host "`n   Welcher Benutzer soll geloescht werden?`n"                                                      # Zu loeschender User auswaehlen

    Remove-ADUser -Identity $aduserrokill                                                                                           # User loeschen

    $stringuserkill = [System.String]::Concat("  Benutzer ", $aduserrokill, " geloescht!")

    Clear-Host
    Write-Host $stringhost -ForegroundColor Red
    Write-Host "                                                 __    " -ForegroundColor White
    Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
    Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
    Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
    Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
    Write-Host "             \/           \/           \/              " -ForegroundColor White
    Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host $ougruppeactive -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host $stringuserkill
    Start-Sleep -Seconds 1.5

}
#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host $stringbegruessung
Write-Host "                                                 __        " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_      " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\     " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |       " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|... :D " -ForegroundColor White
Write-Host "             \/           \/           \/                  " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Start-Sleep -Seconds 1.5


Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
Write-Host $stringverbindungsaufbau
Write-Host "`n------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
Start-Sleep -Seconds 1.5
$domaincred = Get-Credential                                                                                                    # Credentials abfragen
Clear-Host

$dcsession = New-PSSession -ComputerName $lokalerdcname -Credential $domaincred -Name $dcsessionname                            # PSSession vorbereiten
Invoke-Command $dcsession -Scriptblock { Import-Module ActiveDirectory }                                                        # PSSession aufbauen
Import-PSSession -Session $dcsession -module ActiveDirectory                                                                    # PSSession auf DC ausfuehren


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
do{
    Show-MenuAD
    $input = Read-Host "Aufgabe?"
    switch ($input)
    {
       1 { $ougruppeactive = $ougruppe1
            menugroupactive $ougruppeactive }                                                                                   # Aktion Taste 1 - OU-Group 1 bearbeiten
       2 { $ougruppeactive = $ougruppe2
        menugroupactive $ougruppeactive }                                                                                       # Aktion Taste 2 - OU-Group 2 bearbeiten

    }
}
until ($input -eq 'q') 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Disconnect-PSSession -Name $dcsessionname                                                                                       # PSSession trennen

Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "   VERNUNVT MIT V!!!111!!1!  :D `n                     " -ForegroundColor Blue
Start-Sleep -Seconds 1

$Host.UI.RawUI.BackgroundColor = 'Green'      # Script Hintergrundfarbe
Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "   VERNUNVT MIT V!!!111!!1!  :D `n                     " -ForegroundColor Blue
Start-Sleep -Seconds 0.6
$Host.UI.RawUI.BackgroundColor = 'Blue'      # Script Hintergrundfarbe
Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "   VERNUNVT MIT V!!!111!!1!  :D `n                     " -ForegroundColor Blue
Start-Sleep -Seconds 0.6
$Host.UI.RawUI.BackgroundColor = 'Red'      # Script Hintergrundfarbe
Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "   VERNUNVT MIT V!!!111!!1!  :D `n                     " -ForegroundColor Blue
Start-Sleep -Seconds 0.6
$Host.UI.RawUI.BackgroundColor = 'Magenta'      # Script Hintergrundfarbe
Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "   VERNUNVT MIT V!!!111!!1!  :D `n                     " -ForegroundColor Blue
Start-Sleep -Seconds 0.6
$Host.UI.RawUI.BackgroundColor = 'Yellow'      # Script Hintergrundfarbe
Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "   VERNUNVT MIT V!!!111!!1!  :D `n                     " -ForegroundColor Blue
Start-Sleep -Seconds 0.6
$Host.UI.RawUI.BackgroundColor = 'Cyan'      # Script Hintergrundfarbe
Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "   VERNUNVT MIT V!!!111!!1!  :D `n                     " -ForegroundColor Blue
Start-Sleep -Seconds 0.6
$Host.UI.RawUI.BackgroundColor = 'DarkBlue'      # Script Hintergrundfarbe
Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "                                                 __    " -ForegroundColor White
Write-Host "  ___  __ ___________  ____  __ __  _______  ___/  |_  " -ForegroundColor White
Write-Host "  \  \/ // __ \_  __ \/    \|  |  \/    \  \/ /\   __\ " -ForegroundColor White
Write-Host "   \   /\  ___/|  | \/   |  \  |  /   |  \   /  |  |   " -ForegroundColor White
Write-Host "    \_/  \___  >__|  |___|  /____/|___|  /\_/   |__|   " -ForegroundColor White
Write-Host "             \/           \/           \/              " -ForegroundColor White
Write-Host "  VEReinfachtes NUtzer Nachbearbeitungs- & Verwaltungs- Tool" -ForegroundColor Green
Write-Host "   VERNUNVT MIT V!!!111!!1!  :D `n                     " -ForegroundColor Blue
Start-Sleep -Seconds 0.6
Clear-Host

stop-process -Id $PID

