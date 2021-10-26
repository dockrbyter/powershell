<#
.SYNOPSIS
    Liest CSV-Dateien und erstellt neue SCV-Datei aus vorhandenen Daten 
.DESCRIPTION
    Edit SETTINGS-Block!

    $impdeli - Delimeter der Import-Datei  - Nur bei Bedarf editieren
    $expdeli - Delimeter der Export-Datei - Nur bei Bedarf editieren
    $scriptspeed - Darstellungsdauer - Nur bei Bedarf editieren
    $fmode - Floating Mode - Nur bei Bedarf editieren

    Alle relevanten, aber nicht via SETTINGS konfigurierten Werte, werden waehrend
    der Ausfuehrung interaktiv abgefragt.

    KEINE Dublettenueberpruefung!
.EXAMPLE
    PS> .\csvmerger.ps1
.LINK
    https://raw.githubusercontent.com/thelamescriptkiddiemax/powershell/master/csvmerger.ps1
#>
#--- SETTINGS -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$importdir = ""                                     # Ordner in dem sich die zu mergenden CSV's befinden    e.g.    C:\importcsvs
$exportpath = ""                                    # Ordner in dem die Merge-CSV erstellt werden soll      e.g.    C:\exportcsv
$exportcsv = ""                                     # Name der zu erstellenden CSV-Datei                    e.g.    merge

$impdeli = ";"                                      # Delimeter der Import-Datei                            e.g.    ;
$expdeli = ";"                                      # Delimeter der Export-Datei                            e.g.    ;

[double]$scriptspeed = 2                            # Timespan to show text in seconds                      e.g.    2
$fmode = ""                                         # Floating Mode (for debugging)                         e.g.    x

#--- Functions ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$scriptname = $MyInvocation.MyCommand.Name
# Scripthead
function scripthead
{
    # Stringhostinfos
    $tringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", (Get-WmiObject Win32_ComputerSystem).Domain, " -", (Get-CimInstance Win32_OperatingSystem).Caption, ": ", 
    ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm"), "`n", "[ ", $scriptname, " ]", "`n","`n") 
    $tringhost = $tringhost.replace("Microsoft "," ").replace("}", " ")

    # fmode
    if (!$fmode)
    {
        Clear-Host
    }

    Write-Host $tringhost -ForegroundColor Magenta
    Write-Host " _________   _____________   ____                                     " -ForegroundColor DarkMagenta
    Write-Host " \_   ___ \ /   _____/\   \ /   /   _____   ___________  ____   ____  " -ForegroundColor DarkMagenta
    Write-Host " /    \  \/ \_____  \  \   Y   /   /     \_/ __ \_  __ \/ ___\_/ __ \ " -ForegroundColor DarkMagenta
    Write-Host " \     \____/        \  \     /   |  Y Y  \  ___/|  | \/ /_/  >  ___/ " -ForegroundColor DarkMagenta
    Write-Host "  \______  /_______  /   \___/    |__|_|  /\___  >__|  \___  / \___  >" -ForegroundColor DarkMagenta
    Write-Host "         \/        \/                   \/     \/     /_____/      \/ " -ForegroundColor DarkMagenta
    Write-Host "`n"
}

# Display timespan
function scriptspeed ($scriptspeed)
{
    Start-Sleep -Seconds $scriptspeed
}

#--- Processing ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead
scriptspeed $scriptspeed

if (!$exportcsv) {
    scripthead
    $exportcsv = Read-Host "   CSV-Name? (ohne Dateiendung) [Enter fuer merged]"

    if (!$exportcsv) {
        $exportcsv = "merged"
    }
}

if (!$importdir) {
    scripthead
    $importdir = Read-Host "   Import-Ordner? [Enter fuer Script-Directory]"

    if (!$importdir) {
        $importdir = $PWD.Path
    }
}

if (!$exportpath) {
    scripthead
    $exportpath = Read-Host "   Export-Ordner? [Enter fuer Script-Directory]"

    if (!$exportpath) {
        $exportpath = $PWD.Path
    }
}

if (!$impdeli) {
    scripthead
    $impdeli = Read-Host "   Import-Delimeter? [Enter fuer ;]"

    if (!$impdeli) {
        $impdeli = ";"
    }
}

if (!$expdeli) {
    scripthead
    $expdeli = Read-Host "   Export-Delimeter? [Enter fuer ;]"

    if (!$expdeli) {
        $expdeli = ";"
    }
}

$exportcsvpath = [System.String]::Concat($exportpath, "\", $exportcsv, ".csv")
$importdir = [System.String]::Concat($importdir, "\*csv")

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead
Write-Host "   Beginne Merge..."
scriptspeed $scriptspeed

Write-Host  $exportcsvpath

Get-ChildItem $importdir | Foreach-Object {
    Import-Csv -Path $_ -Delimiter $impdeli | Export-Csv $exportcsvpath -Append -NoTypeInformation -Delimiter $expdeli
}

scripthead
Write-Host "   ...Merge erledigt!"
Write-Host ""
scriptspeed $scriptspeed
