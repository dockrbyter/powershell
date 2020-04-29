<#
vernunvt.ps1
.DESCRIPTION

    VEReinfachtesNUtzerNachbearbeitungs&VerwaltungsTool

    Verinfachte AD-Oberflaeche zur Verwaltung
    von Benutzern

    - User aus Vorlage erstellen
    - Vorhandenen User kopieren
    - Passwort zuruecksetzen
    - Benutzer loeschen
    - Benutzer einer Gruppe exportieren (CSV)

    !! Benoetigt Domain-Administrator-Rechte!
    !! Benoetigt RSAT!
    !! RSAT-Installlationserfolg abhaengig von Windowsversion! Fruehere Version als 1809
       erfordert manuelle Installation. Downloadlink RSAT:
       https://www.microsoft.com/en-us/download/details.aspx?id=45520
       Bei automatischer RSAT-Installation wird RSAT bei System-Shutdown entfernt.

https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$domainlokalname = "maexico"            # Name der Domain BSP: "domain"
$domainlokalsuffix = "party"            # Suffix der Domain BSP "local"

$ougruppe1 = "thralls"                  # Namde der zu verwaltenden OU-Group 1
$ougruppe1vorlage = "thrallblanko"      # Vorlageprofil der OU-Group 1, aus dem neue User generiert werden sollen

$ougruppe2 = "minions"                  # Namde der zu verwaltenden OU-Group 2
$ougruppe2vorlage  = "minionsblanko"    # Vorlageprofil der OU-Group 2, aus dem neue User generiert werden sollen

$exportpfad = "C:\Benutzerexport"       # Dateipfad fuer CSV-Export     BSP C:\Benutzerexport


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
#$stringbegruessung = [System.String]::Concat($env:UserName, ", probiers mal mit")
$stringmenuad1 = [System.String]::Concat("     Taste 1 fuer Bearbeitung von ", $ougruppe1)
$stringmenuad2 = [System.String]::Concat("     Taste 2 fuer Bearbeitung von ", $ougruppe2)
$menugroupactive2 = "  Taste 2 ---- Kopieren eines vorhandenen Benutzers"
$menugroupactive3 = "  Taste 3 ---- Zuruecksetzen des Passwortes eines Benutzers"
$menugroupactive4 = "  Taste 4 ---- Loeschen eines Benutzers"

$Host.UI.RawUI.BackgroundColor = 'Magenta'                                                                                                                      # Script Hintergrundfarbe
$Host.UI.RawUI.ForegroundColor = 'Yellow'                                                                                                                       # Script Textfarbe

Clear-Host
Write-Host $stringhost -ForegroundColor Red
Write-Host "   VERNUNVT   System bereit machen..."
Start-Sleep -Seconds 1.5

Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
Import-Module ActiveDirectory


#--- Funktionen ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function headline {
    
    # Darstellung Headline

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
    
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function endline {
    
    # Darstellung Endline

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

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Show-MenuAD
{
    param ([string]$Title = "     Hauptmenu")

    # Darstellung Auswahl Benutzergruppe

    headline
    Write-Host $stringmenuad1
    Write-Host $stringmenuad2
    Write-Host "     Taste Q zum Beenden"
    Write-Host "`n------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function menugroupactive ($ougruppeactive) {

    $menugroupactive1 = [System.String]::Concat("  Taste 1 ---- Erstellen eines neuen Benutzers aus Standardvorlage fuer ", $ougruppeactive)
    $menugroupactive5 = [System.String]::Concat("  Taste 5 ---- Alle Benutzer der Gruppe ", $ougruppeactive, " ausgeben")

    do{
        
        # Darstellung Auswahl Aktionen

        headline
        Write-Host $menugroupactive1
        Write-Host $menugroupactive2
        Write-Host $menugroupactive3
        Write-Host $menugroupactive4
        Write-Host $menugroupactive5
        Write-Host "  Taste Q ---- Zurueck zum Hauptmenu `n"
        Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan

        $input = Read-Host "Aufgabe?"
        switch ($input)
        {

           1 { adusercreate $ougruppeactive }                                                                                                               # Aktion Taste 1 - Erstellen eines neuen Benutzers
           2 { adusercopy $ougruppeactive }                                                                                                                 # Aktion Taste 2 - Kopieren eines vorhandenen Benutzers
           3 { aduserpwchange $ougruppeactive }                                                                                                             # Aktion Taste 3 - Aendern des Passwortes eines Benutzers
           4 { aduserkill $ougruppeactive }                                                                                                                 # Aktion Taste 4 - Loeschen eines Benutzers
           5 { aduserexport $ougruppeactive $exportpfad $domainlokalname $domainlokalsuffix }                                                               # Aktion Taste 5 - Alle Benutzer ausgeben
    
        }
    }
    until ($input -eq 'q') 

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function adusercreate ($ougruppeactive) {
    
    # Benutzer von Vorlage erstellen

    if ($ougruppeactive = $ougruppe1 ) {
        $ougruppevorlactive = $ougruppe1vorlage
    }
    else {
        $ougruppevorlactive = $ougruppe2vorlage
    }

    
    headline
    $neueruserVorNAME = Read-Host "`n   Vorname des neuen Benutzers eingeben (BSP Maximilian)`n"                                                            # Vorname Neuer User
	$neueruserNachNAME = Read-Host "`n   Nachname des neuen Benutzers eingeben (BSP Mustermeister)`n"                                                       # Nachname Neuer User
    $startpw = Read-Host "`n   Start-Passwort des neuen Benutzers eingeben (BSP Start123)`n"                                                                # Init-Passwort

    $startpwS = ConvertTo-SecureString $startpw -AsPlainText -Force                                                                                         # Passwortstring convertieren
    
    $userName = [System.String]::Concat($neueruserVorNAME, ".", $neueruserNachNAME)                                                                         # Benutzername generieren
	$userPrincipal = [System.String]::Concat($neueruserVorNAME, ".", $neueruserNachNAME, "@", $domainlokalname, ".", $domainlokalsuffix)                    # Principal generieren
    $userDisplay = [System.String]::Concat($neueruserVorNAME, " ", $neueruserNachNAME)                                                                      # Anzeigename generieren

    $stringusererstellt = [System.String]::Concat("  Neuer Benutzer ", $userName, "`n  nach Vorlage ", $ougruppevorlactive, " erstellt!", "`n `n", "   Das Start-Passwort lautet: ", $startpw, "`n `n", "   Der Benutzer wird bei der ersten Anmeldung aufgefordert das Passwort zu aendern!")

    $uservorlage = Get-AdUser -Identity $ougruppevorlactive -Properties memberof                                                                            # TemplateUser einlesen
    $path = (Get-AdUser $ougruppevorlactive).distinguishedName.Split(',',2)[1]                                                                              # OU-Pfad generieren
    $memberof = Get-ADPrincipalGroupMembership $ougruppevorlactive                                                                                          # Membership von Template einlesen
    
    $ErrorActionPreference = 'SilentlyContinue'                                                                                                             # Vorhandene Mitgliedschaften ignorieren

    New-ADUser -Instance $uservorlage -Name $userName -GivenName $neueruserVorNAME -Surname $neueruserNachNAME -DisplayName $userDisplay -path $path -UserPrincipalName $userPrincipal -AccountPassword $startpwS -ChangePasswordAtLogon $true      # Benutzer erstellen
    Add-ADPrincipalGroupmembership -Identity $userName -MemberOf $memberof | Out-Null                                                                                                                                                               # Gruppen hinzufuegen

    headline
    Write-Host $stringusererstellt
    Pause

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function adusercopy ($ougruppeactive) {
    
    # Benutzer von spezifischer Vorlage erstellen

    headline
    $vorlageuser = Read-Host "`n   Benutzername des zu kopierenden Benutzers eingeben (BSP Maximilian.Mustermeister)`n"                                     # Template abfragen
    $neueruserVorNAME = Read-Host "`n   Vorname des neuen Benutzers eingeben (BSP Maximilian)`n"                                                            # Vorname Neuer User
	$neueruserNachNAME = Read-Host "`n   Nachname des neuen Benutzers eingeben (BSP Mustermeister)`n"                                                       # Nachname Neuer User
    $startpw = Read-Host "`n   Start-Passwort des neuen Benutzers eingeben (BSP Start123)`n"                                                                # Init-Passwort
    
    $startpwS = ConvertTo-SecureString $startpw -AsPlainText -Force

    $userName = [System.String]::Concat($neueruserVorNAME, ".", $neueruserNachNAME)                                                                         # Benutzername generieren
	$userPrincipal = [System.String]::Concat($neueruserVorNAME, ".", $neueruserNachNAME, "@", $domainlokalname, ".", $domainlokalsuffix)                    # Principal generieren
    $userDisplay = [System.String]::Concat($neueruserVorNAME, " ", $neueruserNachNAME)                                                                      # Anzeigename generieren

    $stringusererstellt = [System.String]::Concat("  Neuer Benutzer ", $userName, "`n  nach Vorlage ", $vorlageuser, " erstellt!", "`n `n", "   Das Start-Passwort lautet: ", $startpw, "`n `n", "   Der Benutzer wird bei der ersten Anmeldung aufgefordert das Passwort zu aendern!")

    $uservorlage = Get-AdUser -Identity $vorlageuser -Properties memberof                                                                                   # TemplateUser einlesen
    $path = (Get-AdUser $vorlageuser).distinguishedName.Split(',',2)[1]                                                                                     # OU-Pfad generieren
    $memberof = Get-ADPrincipalGroupMembership $vorlageuser                                                                                                 # Membership von Template einlesen

    $ErrorActionPreference = 'SilentlyContinue'                                                                                                             # Vorhandene Mitgliedschaften ignorieren
    
    New-ADUser -Instance $uservorlage -Name $userName -GivenName $neueruserVorNAME -Surname $neueruserNachNAME -DisplayName $userDisplay -path $path -UserPrincipalName $userPrincipal -AccountPassword $startpwS -ChangePasswordAtLogon $true
    Add-ADPrincipalGroupmembership -Identity $userName -MemberOf $memberof | Out-Null

    headline
    Write-Host $stringusererstellt
    Pause

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function aduserpwchange ($ougruppeactive) {

    # Passwort Reset

    headline
    $aduserpwchange = Read-Host "`n   Benutzername fuer Passwort-Reset eingeben (BSP Maximilian.Mustermeister)`n"                                           # User dessen Passwort geaendert werden soll auswaehlen
    $startpw = Read-Host "`n   Reset-Passwort des Benutzers eingeben (BSP Start123)`n"                                                                      # Neues User-Passwort abfragen

    $startpwS = ConvertTo-SecureString $startpw -AsPlainText -Force

    $stringpwchange = [System.String]::Concat("  Passwort von ", $aduserpwchange, "`n  zurueckgesetzt! ", "`n `n", "   Das Reset-Passwort lautet: ", $startpw, "`n `n", "   Der Benutzer wird bei der naechsten Anmeldung aufgefordert das Passwort zu aendern!")

    Get-AdUser -Identity $aduserpwchange | Set-ADAccountPassword -NewPassword $startpwS                                                                     # Passwort aendern

    headline
    Write-Host $stringpwchange
    Pause

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function aduserkill ($ougruppeactive) {
    
    # Benutzer Loeschen

    headline
    $aduserkill = Read-Host "`n   Welcher Benutzer soll geloescht werden? (BSP Maximilian.Mustermeister)`n"                                                 # Zu loeschender User auswaehlen

    Remove-ADUser -Identity $aduserkill -Confirm:$false                                                                                                     # User loeschen

    $stringuserkill = [System.String]::Concat("  Benutzer ", $aduserkill, " geloescht!")

    headline
    Write-Host $stringuserkill
    Start-Sleep -Seconds 4

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function aduserexport ($ougruppeactive, $exportpfad, $domainlokalname, $domainlokalsuffix) {
    
    # Benutzerausgabe

    if ($ougruppeactive = $ougruppe1 ) {
        $ougruppevorlactive = $ougruppe1vorlage
    }
    else {
        $ougruppevorlactive = $ougruppe2vorlage
    }

        $path = (Get-AdUser $ougruppevorlactive).distinguishedName.Split(',',2)[1]                                                                              # OU-Pfad generieren
        $csvdatei = [System.String]::Concat($domainlokalname,".",$domainlokalsuffix, "_", $ougruppeactive, "_", (Get-Date -Format "dd/MM/yyyy"), ".csv")        # CSV-Name generieren
        $csvpath1 = [System.String]::Concat($exportpfad,"\raw.csv")                                                                                             # CSV-RAW Pfad
        $csvpath2 = [System.String]::Concat($exportpfad,"\", $csvdatei)                                                                                         # CSV-Final Pfad
        $stringcsverstellt = [System.String]::Concat("`n   ", $csvpath2, " erstellt! `n")

        $alleaduser = Get-ADUser -Filter * -SearchBase $path | Select-object Surname,GivenName,Name,UserPrincipalName                                           # ADUser aus aktiver Gruppe einlesen

        Add-Type -AssemblyName System.Windows.Forms                                                                                                             # Prompt-Module laden

        headline
        $exportauswahl=[System.Windows.Forms.MessageBox]::Show("$($selection.Application) Benoetigen Sie eine CSV-Datei?" , "VERNUNVT CSV-Export" , 4)          # Prompt einblenden

        if ($exportauswahl -eq "Yes") 
        {
            
            If(!(test-path $exportpfad))
        {
            New-Item -ItemType Directory -Force -Path $exportpfad                                                                                               # Ordernerpfad erstellen, wenn nicht existent
         
        }
    
            $alleaduser | Export-Csv -NoTypeInformation -Path $csvpath1                                                                                         # CSV Raw erstellen
            Import-Csv -Path $csvpath1 -Header Nachname,Vorname,Anmeldename,SAM-Name | Select-Object -Skip 1 | Export-Csv -NoTypeInformation -Path $csvpath2    # CSV Header anpassen
            Remove-Item -Path $csvpath1                                                                                                                         # RAW CSV entfernen
            
            headline
            Write-Host $stringcsverstellt
            Start-Sleep -Seconds 5
        
        }
        else 
        {
            
            headline
            Format-Table -InputObject $alleaduser                                                                                                               # ADUser in Script ausgeben
            Pause

        }
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
do{
    
    # Mainmenu einblenden
    
    Show-MenuAD
    $input = Read-Host "Zu bearbeitender Nutzertyp?"
    switch ($input)
    {
       1 { $ougruppeactive = $ougruppe1
            menugroupactive $ougruppeactive
			}                                                                                                                                                   # Aktion Taste 1 - OU-Group 1 bearbeiten
       2 { $ougruppeactive = $ougruppe2
            menugroupactive $ougruppeactive
		    }                                                                                                                                                   # Aktion Taste 2 - OU-Group 2 bearbeiten

    }
}
until ($input -eq 'q') 


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

endline

$Host.UI.RawUI.BackgroundColor = 'Green'                                                                                                                        # Script Hintergrundfarbe
endline

$Host.UI.RawUI.BackgroundColor = 'Blue'                                                                                                                         # Script Hintergrundfarbe
endline

$Host.UI.RawUI.BackgroundColor = 'Magenta'                                                                                                                      # Script Hintergrundfarbe
endline

$Host.UI.RawUI.BackgroundColor = 'Yellow'                                                                                                                       # Script Hintergrundfarbe
endline

$Host.UI.RawUI.BackgroundColor = 'DarkBlue'                                                                                                                     # Script Hintergrundfarbe
endline

Remove-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0                                                                             # RSAT von Client entfernen

stop-process -Id $PID                                                                                                                                           # Script beenden

