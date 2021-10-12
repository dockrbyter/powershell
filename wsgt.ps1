<#
.SYNOPSIS
    Sammelt Host-Daten und fuegt diese in CSV-Datein ein, prophylaktisches gpupdate
.DESCRIPTION
    Edit SETTINGS-Block!

    $csvname - Name der CSV-Datei (ohne Pfad, oder Dateieindung)
    $domaincon - Hostname des Domaincontrollers
    $zusatzsetuppa - Pfad zum Installer von Zusatzsoftware
.EXAMPLE
    PS> .\wsgt.ps1
.LINK
    https://github.com/thelamescriptkiddiemax/powershell
#>
#--- SETTINGS -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$csvname = ""               # Name der CSV-Datei                                EG  inventar
$domaincon = ""             # Hostname Domaincontoller                          EG  megadc
$zusatzsetuppa = ""         # Pfad zu Zusatzinstaller                           EG  \\share\shareshare\file.exe
$zusatzsona = ""            # Name der Zusatzsoftware                           EG  NICE-Soft

$scriptspeed = 2            # Darstellungsdauer der Textausgaben in Sekunden    EG  2
$fmode = ""                 # Floating Mode (fuer Debugging)                    EG  x

#--- VARIABLES ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$ourcefolder = $PSScriptRoot                            
$csvtestpa = [System.String]::Concat($ourcefolder, "\", $csvname, ".csv")
$tringabschlu = [System.String]::Concat("`n     Es folgen ein par prophylaktische GP-Updates,`n     damit ist die Bearbeitung von Workstation: ", $env:computername, " erledigt! `n `n     Weiter zum naechsten System... :D `n `n")
$tringhona = [System.String]::Concat("AKTUELLER HOST: ", $env:computername)
$tringinst = [System.String]::Concat("     Bitte geben Sie nun an, ob Sie ", $zusatzsona, " installiert haben.")
$tringakt = [System.String]::Concat("     Bitte geben Sie nun an, ob Sie ", $zusatzsona, " aktiviert haben.")

$prop1 = "Raum"
$prop2 = "Hostname"
$prop3 = "WMI Test lokal"
$prop4 = "WMI Test Domain"
$prop5 = "Office aktiviert"
$prop6 = [System.String]::Concat($zusatzsona, " installiert")
$prop7 = [System.String]::Concat($zusatzsona, " aktiviert")
$prop8 = "SuS Auto-Logon"

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
    Write-Host "    WSGT" -ForegroundColor Blue
    Write-Host "`n"
}

# Dauer Einblendungen
function scriptspeed ($scriptspeed)
{
    Start-Sleep -Seconds $scriptspeed
}

# Einblendungen
function stringmp {
    Write-Host "`n `n      MANUELLE UEBERPRUEFUNG `n" -ForegroundColor Yellow
}

# Interativeres Gefuehl
function talky ($ayin) {
    Add-Type -AssemblyName System.speech
    $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $speak.Speak($ayin)
}

#--- EXECUTION ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead
Write-Host "`n `n      Fuehre automatisierte Checks durch... `n" -ForegroundColor Yellow
scriptspeed $scriptspeed

# WMI-Firewall Rule und Service Neustart
netsh firewall set service RemoteAdmin enable
restart-service winmgmt -Force

# Raum Variable erstellen
$1raum = $env:computername
$1raum = $1raum.replace("LE-NB-"," ")
$1raum = $1raum.SubString(0,4)

# Hostname Variable erstellen
$2host = $env:computername


# TryCatch WMI Lokal
Try {
    Get-WmiObject -query "SELECT * FROM Win32_OperatingSystem"
    $3wmil = "X"
}
Catch {
    $3wmil = "NA"
}

# TryCatch WMI Domain
Try {
    Get-WmiObject -query "SELECT * FROM Win32_OperatingSystem" -ComputerName $domaincon
    $4wmid = "X"
}
Catch {
    $4wmid = "NA"
}

scripthead
Write-Host "`n `n      Automatisierte Checks erledigt! `n"
scriptspeed $scriptspeed

$ayin = "Kevin, bleib bei der Sache!"
talky $ayin
Start-Sleep -Seconds 2

$ayin = "Check Office!"
# Office Check
scripthead
talky $ayin
stringmp
Write-Host "MS Office"
Write-Host "     Bitte ueberpruefen Sie nun, ob MS Office aktiviert ist."
scriptspeed $scriptspeed

$confirmation1 = Read-Host "   Ist MS Office aktiviert? [1 Aktiviert / 2 NICHT aktiviert]"
if ($confirmation1 -eq '1') {
    $5office = "X"
}else {
    $5office = "NICHT aktiviert"
}

$ayin = $zusatzsona
# Zusatzsoftware Check
scripthead
talky $ayin
stringmp
Write-Host $zusatzsona
Write-Host $tringinst
scriptspeed $scriptspeed

$confirmation2 = Read-Host "   Ist Zusatz-Software installiert? [1 installiert / 2 NICHT installiert]"
if ($confirmation2 -eq '2') {
    Write-Host "   Oeffne Explorer, bitte Zusatz-Software installieren und aktivieren. Ich warte..."
    Write-Host "Eventuelle Reboots NICHT durchfuehren!" -ForegroundColor Red
    Invoke-Expression "explorer '/select,$zusatzsetuppa'"
    Write-Host "   Bitte druecken Sie Enter, wenn Sie die Installation, so wie die Aktvierung abgeschlossen haben."
    Pause
    $6smartnbi = "X"
}else {
    $6smartnbi = "X"
}

scripthead
stringmp
Write-Host $zusatzsona
Write-Host $tringakt
scriptspeed $scriptspeed

$confirmation3 = Read-Host "   Ist die Zusatz-Software aktiviert? [1 Aktiviert / 2 NICHT aktiviert]"
if ($confirmation3 -eq '1') {
    $7smartnba = "X"
}else {
    $7smartnba = "NICHT aktiviert"
}

# Auto LogOn Check
scripthead
stringmp
Write-Host "SuS AutoLogon"
Write-Host "     Bitte ueperpruefen Sie nun, ob es sich bei dem aktuellen Host um eine LuL-, oder Sus-WorkStation handelt"
Write-Host $tringhona -ForegroundColor Yellow
scriptspeed $scriptspeed

$confirmation4 = Read-Host "   Ist der aktuelle Host eine LuL-WS, oder eine SuS-WS? [1 LuL / 2 SuS]"
if ($confirmation4 -eq '1') {
    Write-Host "`n     LuL-WS: AutoLogon wird NICHT aktiviert! `n"
    $8al = "LuL-WS"
}else {
    Write-Host "`n     SuS-WS: Aktiviere AutoLogon... `n"
    $ragpaal = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    Set-ItemProperty $ragpaal 'AutoAdminLogon' -Value "1" -Type String 
    Set-ItemProperty $ragpaal 'DefaultUsername' -Value $env:computername -type String
    $8al = "X"
}

# CSV Erfassung
scripthead
Write-Host "   Datenerfassung abgeschlossen! Ergaenze CSV..."
scriptspeed $scriptspeed

$newrow = New-Object PSObject -Property @{
    $prop1 = $1raum
    $prop2 = $2host
    $prop3 = $3wmil
    $prop4 = $4wmid
    $prop5 = $5office
    $prop6 = $6smartnbi
    $prop7 = $7smartnba
    $prop8 = $8al
}

$newrow | Select-Object $prop1, $prop2, $prop3, $prop4, $prop5, $prop6, $prop7, $prop8 | Export-Csv $csvtestpa -Append -NoTypeInformation -Delimiter ";"

$ayin = "Ok zieh mich raus"

scripthead
Write-Host $tringabschlu
scriptspeed $scriptspeed

Start-Sleep -Seconds 1
talky $ayin

# GPupdate mit Reboot (Restart-Computer angefuegt falls gpupdate kein Reboot startet)
Invoke-GPUpdate -Force
Restart-Computer -Force -ErrorAction SilentlyContinue

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
