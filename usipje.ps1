<#
.SYNOPSIS
    Importiert User aus CSV in Domain-OU, setzt auf Wunsch Gruppenzugehörigkeit

.DESCRIPTION
    Edit SETTINGS-Block!

    $tartpw - Init-Passwort -> Wenn $tartpw = CSV, wird dass Passwort aus der CSV ausgelesen.
    Der entsprechende Header MUSS MANUELL ANGEFUEGT WERDEN!

    (Somit ist es unmoeglich das Start-Passwort "CSV" zu vergeben)

    $tandardus - User Exportvorlage
    $tartgroup - Gruppe fuer Import-User
    $scriptspeed - Darstellungsdauer - Nur bei Bedarf editieren
    $fmode - Floating Mode - Nur bei Bedarf editieren

    Importierte User werden direkt beim Einlesen auf Active gesetzt und muessen das Passwort bei der Erstanmeldung aendern!

    Script starten und CSV mit Export-User erstellen. CSV-Datei mit neuen Usern erweitern, Export-User aus CSV loeschen (Zeile 2).
    Script erneut starten und die Magie geniessen...

.EXAMPLE
    PS> .\usipje.ps1

.LINK
    https://github.com/thelamescriptkiddiemax/powershell
#>
#--- SETTINGS -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$tartpw = ""                                            # Init-Passwort fuer die neuen User, leer lassen fuer interaktive Abfrage                                               E.G.  StartPW987
$tandardus = ""                                         # User fuer Exportvorlage, leer lassen fuer interaktive Abfrage                                                         E.G.  TestDude
$tartgroup = ""                                         # Gruppe der die User zugewiesen werden sollen, leer lassen fuer interaktive Abfrage, bzw. keine Gruppenzuweisung       E.G.  WorkerDudes

$scriptspeed = 2                                        # Darstellungsdauer der Textausgaben in Sekunden                                                                        E.G.  2
$fmode = ""                                             # Floating Mode (fuer Debugging)                                                                                        E.G.  x

#--- VARIABLES ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$ourcefolder = $PSScriptRoot                            # Script Location festlegen
$csvn = "\usip.csv"                                     # CSV-Datei-Name vergeben
$csvtestpa = ($ourcefolder+$csvn)                       # CSV-Datei-Pfad erstellen

#--- FUNCTIONS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Script Header-Einblendungen
$scriptname = $MyInvocation.MyCommand.Name
# Scripthead
function scripthead
{

    # Stringhostinfos
    
    $tringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " -", (Get-CimInstance Win32_OperatingSystem).Caption, ": ", 
    ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm"), "`n", "[ ", $scriptname, " ]", "`n","`n") 
    $tringhost = $tringhost.replace("Microsoft "," ").replace("}", " ")

    # fmode
    if (!$fmode)
    {
        Clear-Host
    }

    Write-Host $tringhost -ForegroundColor Magenta
    Write-Host "    _     ____  _  ____ " -ForegroundColor Blue
    Write-Host "   / \ /\/ ___\/ \/  __\" -ForegroundColor Blue
    Write-Host "   | | |||    \| ||  \/|" -ForegroundColor Blue
    Write-Host "   | \_/|\___ || ||  __/   J-Edition" -ForegroundColor Blue
    Write-Host "   \____/\____/\_/\_/   " -ForegroundColor Blue
    Write-Host "`n"
}

# Dauer Einblendungen
function scriptspeed ($scriptspeed)
{
    Start-Sleep -Seconds $scriptspeed
}

#--- EXECUTION ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead
scriptspeed $scriptspeed

# First Run Check - Wenn CSV-Datei nicht vorhanden...
if (!(Test-Path -Path $csvtestpa -PathType Leaf)) {

    $dcget = (Get-ADDomainController).ComputerObjectDN                              # Domain Controller -Informationen sammeln
    $tringdci = [System.String]::Concat("`n Path: >     ", $dcget, "     < `n")     # Ausgabe-String erstellen

    scripthead
    Write-Host "   Konnte keine CSV finden! `n"
    scriptspeed $scriptspeed

    scripthead
    Write-Host "   Bitte manuell einen Beispiel-User fuer Exportvorlage erstellen (Script-Default: TestUser) `n"
    Write-Host "--------------------------------------------------------------------------"
    Write-Host $tringdci
    Write-Host "  -1- Entsprechende OU erstellen (falls nicht bereits vorhanden)"
    Write-Host "  -1- New-ADOrganizationalUnit -Name 'ouname' -Path 'DC=dcname,DC=dcname'"
    Write-Host "  -2- Entsprechenden User erstellen (falls nicht bereits vorhanden)"
    Write-Host "  -2- New-ADUser -Name 'username' -DisplayName 'displayname' -Surname 'surname' -GivenName 'givenname' -Path 'DC=dcname,DC=dcname'"
    Write-Host "--------------------------------------------------------------------------"
    Write-Host "   Bestaetigen Sie mit Enter, NACHDEM Sie den Beispiel-User erstellt haben" -ForegroundColor DarkGreen
    Pause

    # Wenn $tandardus NULL...
    if (!$tandardus) {
        scripthead
        $tandardus = Read-Host -Prompt "   Wie haben Sie den User fuer die Exportvorlage nenannt? Leer lassen fuer TestUser"        # Erfrage Export-User
    
        # Wenn $tandardus NULL...
        if (!$tandardus) {
            $tandardus = "TestUser"         # $tandardus = TestUser
        }
    }

    $tringncsv = [System.String]::Concat("   CSV wird anahnd von User: ", $tandardus, " erstellt... `n `n")                         # Textausgabe erstellen
    Write-Host $tringncsv -ForegroundColor Yellow                                                                                   # Textausgabe darstellen

    Get-ADUser -Identity $tandardus -Properties * | Select-Object Name, DisplayName, Surname, GivenName,SamAccountName, @{n='OU';e={[regex]::match($_.DistinguishedName,'(?is)OU=.*').Value}} | export-csv -path $csvtestpa -Delimiter ";"      # Export-User als Objekt laden, Werte fuer CSV trimmen, nach CSV exportieren
    (Get-Content $csvtestpa | Select-Object -Skip 1) | Set-Content $csvtestpa                                                                                                                                                                   # Oberste Zeile aus CSV entfernen

    # Hinweis-Textausgabe erstellen
    $tringusert = [System.String]::Concat("   Bitte den Headdern ensprechend ausfuellen und das Script erneut starten. `n     Vergessen Sie nicht den Eintrag des Beispiel-Users: <", $tandardus, "> (Zeile 2) in der Datei zu entfernen! `n     Dieser dient nur als Vorlage fuer Ihren Import und sollte später nicht eingelesen werden! `n `n")

    # Diverse Textausgaben
    scripthead
    Write-Host "   Import-CSV erstellt! `n    (in Script-Location) `n `n     " -ForegroundColor Yellow
    Write-Host $tringusert
    Write-Host "      Bitte bestaetigen Sie (Enter), dass Sie diesen Hinweis gelesen und verstanden haben." -ForegroundColor DarkGreen
    Pause
    Write-Host "Das Script wird in 5 Sekunden beendet..."
    Start-Sleep -Seconds 5
    
    #Script-Ausfuehrung beenden
    Exit
}

# Second Run - CSV-Datei vorhanden
scripthead
Write-Host "`n     CSV gefunden! `n `n"
scriptspeed $scriptspeed

# Wenn $tartpw NULL - erfragen, wenn weiterhun NULL - $tartpw = N1ceStart987
if (!$tartpw) {
    scripthead
    $tartpw = Read-Host -Prompt "   Init-PW fuer die neuen User? Leer lassen fuer N1ceStart987"

    if (!$tartpw ) {
        $tartpw = "N1ceStart987"
    }
}

# AD-PowerSHell-Modul laden
Import-Module ActiveDirectory

# Textausgabe 
scripthead
Write-Host "`n     Beginne User-Import... `n `n"
scriptspeed $scriptspeed

# CSV einlesen
$importusers = Import-Csv $csvtestpa -Delimiter ";"
# Fuer jeden user in users - lese Variablen aus CSV ein und erstelle User
foreach ($importuser in $importusers) {
    $userName  = [System.String]::Concat($importuser.Name, ".", $importuser.Surname)
    $displayName = $importuser.DisplayName
    $surname = $importuser.Surname
    $givenName = $importuser.GivenName
    $ouPath = $importuser.OU

    # Wenn $tartpw = CSV, dann lese Passwort aus CSV aus, andersfalls lese Passwort aus Variable
    if ($tartpw -eq "CSV") {
        $accountPassword = (ConvertTo-SecureString $importuser.Passwort -AsPlainText -Force)
    }else {
        $accountPassword = (ConvertTo-SecureString $tartpw -AsPlainText -Force)
    }

    # Neuen AD-User in Itteration erstellen
    New-ADUser -Name $userName -DisplayName $displayName -Surname $surname -GivenName $givenName -Path $ouPath -AccountPassword $accountPassword -Enabled $true -ChangePasswordAtLogon $true -AuthenticationPolicy Name

    # Textausgabe erstellen
    $tringcuru = [System.String]::Concat("`n `n   User erstellt: ",  $DisplayName, " `n `n")

    # Textausgabe 
    scripthead
    Write-Host "     AD-User-Import"
    Write-Host $tringcuru -ForegroundColor Green
}

# Wenn $tartgroup = NULL - erfrage AD-Gruppe, wenn weiterhin NULL - keine Gruppenzuweisung
if (!$tartgroup) {
    scripthead
    Write-Host "   AD-Gruppenzuwesiung"
    $tartgroup = Read-Host -Prompt "   User-Gruppe der soeben erstellten User? Leer lassen wenn keine Gruppenzuweisung erwuenscht ist."

    # Wenn $tartgroup nicht NULL - pruefe ob AD-Gruppe vorhanden
    if (!([string]::IsNullOrEmpty($tartgroup))){
        $tringgroche = [System.String]::Concat("   Pruefe ob gewuenschte AD-Gruppe >> ", $tartgroup, "bereits vorhanden ist....")

        scripthead
        Write-Host "   AD-Gruppenzuwesiung"
        Write-Host $tringgroche
        scriptspeed $scriptspeed

        # Wenn AD-Gruppe vorhanden, Texausgabe AD-Gruppe vorhanden
        if(Get-ADGroup -filter {Name -eq $tartgroup} -ErrorAction Continue)
        {
            scripthead
            Write-Host "   AD-Gruppenzuwesiung"
            Write-Host "   User-Group vorhanden!" -ForegroundColor Yellow
            scriptspeed $scriptspeed

        } else # Andernfalls erstelle AD-Gruppe
            {
                $tringadert = [System.String]::Concat("   User-Group ", $tartgroup, " erstell!")

                scripthead
                Write-Host "   AD-Gruppenzuwesiung"
                Write-Host "   User-Group NICHT vorhanden! Wird erstellt..." -ForegroundColor DarkMagenta
                scriptspeed $scriptspeed

                New-ADGroup -Name $tartgroup -DisplayName $tartgroup -GroupScope Global -GroupCategory Security -Path $ouPath

                scripthead
                Write-Host "   AD-Gruppenzuwesiung"
                Write-Host $tringadert -ForegroundColor Yellow
                scriptspeed $scriptspeed
            }
        
        # Fuer jeden User ins Users - Lese Variablen aus CSV und fuege User User-Gruppe hinzu
        foreach ($importuser in $importusers) {
            $userName  = $importuser.Name
        
            # User der Gruppe zuweisen
            Add-ADGroupMember -Identity $tartgroup -Members $userName
        
            # Textausgaben erstellen
            $tringgrua = [System.String]::Concat("`n `n   User ",  $DisplayName, " zu Gruppe ", $tartgroup, " hinzugefuegt `n `n")

            # Textausgaben
            scripthead
            Write-Host "   AD-Gruppenzuwesiung"
            Write-Host $tringgrua -ForegroundColor Green
        }
    }
}

# Textausgaben - Feuerwerk Job done!
scripthead
Write-Host "`n     User-Import abgeschlossen! `n"
$Host.UI.RawUI.BackgroundColor = 'Green'
scripthead
$Host.UI.RawUI.BackgroundColor = 'Yellow'
scripthead
$Host.UI.RawUI.BackgroundColor = 'Magenta'
scripthead
Write-Host "`n     User-Import abgeschlossen! `n     Script wird in 10 Sekunden beendet..." -ForegroundColor White
Start-Sleep -Seconds 10
scripthead

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Shell schliessen
#Stop-Process -Id $PID
