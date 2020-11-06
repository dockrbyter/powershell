<#
netpenetrator.ps1
.DESCRIPTION

    NetPenetrator - Erzeugt Traffic und logt ihn :D
    
    -> Greift auf CLI von speedtest.net zu!
    -> Check Version @ https://www.speedtest.net/de/apps/cli
    
    Dowloaded die Speedtest.net CLI,
    führt Speedtests durch und laed 3 Downloads von den 4
    moeglichen Links durchs. Die Ergebnisse landen in Log-File
    auf Net-Share.

    Script auf moeglichst vielen Hosts im Netzwerk ausfuehren!!!


https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$dlstl = "https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-win64.zip"                   # Downloadlink Speedtest.exe                        EX  https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-win64.zip

$trafficlink1 = " "                                                                                                     # Downloadlink Traffic-File 1                       EX  https://domain.tld/download/link/file
$trafficlink2 = " "                                                                                                     # Downloadlink Traffic-File 2                       EX  https://domain.tld/download/link/file
$trafficlink3 = " "                                                                                                     # Downloadlink Traffic-File 3                       EX  https://domain.tld/download/link/file
$trafficlink4 = " "                                                                                                     # Downloadlink Traffic-File 4                       EX  https://domain.tld/download/link/file

$logfilename = "penlog.txt"                                                                                             # Loggilfe Name                                     EX  penlog.txt
$logfilepfad = "\\100.100.100.150\logs"                                                                                 # Pfad zu Logfile                                   EX  \\100.100.100.150\logs

$scriptspeed = "2"                                                                                                      # Darstellungsdauer der Textausgaben in Sekunden    EX  2
$fmode = ""                                                                                                             # Floating Mode (fuer Debugging)                    EX  x
$cleanmode = ""                                                                                                         # Clean Mode - loescht Tempfiles                    EX  x

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$scriptname = $MyInvocation.MyCommand.Name          # Scriptname

$penlog = "$logfilepfad\$logfilename"               # Logfile

$penordner = "netpen"                               # TEMP Arbeitsordner
$penenv = "$ENV:Temp\$penordner"                    # TEMP Arbeitsordner
$penlocalfile = "$penenv\pen.txt"                   # Temp File 1
$penlocalfile2 = "$penenv\pen2.txt"                 # Temp File 2
$penexe = "$penenv\speedtest.exe"                   # Spreedtest.exe
$dlzip = "$penenv\download.zip"                     # Speedtest Download Zip
$trafficfile = "$penenv\trafficfile.dat"            # Trafficfile 

# LOGFILE HEADDER
$fileh0 = "netpenetrator.ps1 - Get the script @ https://github.com/thelamescriptkiddiemax/powershell"
$fileh1 = " _        _______ _________ _______  _______  _        _______ _________ _______  _______ _________ _______  _______ "
$fileh2 = "( (    /|(  ____ \\__   __/(  ____ )(  ____ \( (    /|(  ____ \\__   __/(  ____ )(  ___  )\__   __/(  ___  )(  ____ )"
$fileh3 = "|  \  ( || (    \/   ) (   | (    )|| (    \/|  \  ( || (    \/   ) (   | (    )|| (   ) |   ) (   | (   ) || (    )|"
$fileh4 = "|   \ | || (__       | |   | (____)|| (__    |   \ | || (__       | |   | (____)|| (___) |   | |   | |   | || (____)|"
$fileh5 = "| (\ \) ||  __)      | |   |  _____)|  __)   | (\ \) ||  __)      | |   |     __)|  ___  |   | |   | |   | ||     __)"
$fileh6 = "| | \   || (         | |   | (      | (      | | \   || (         | |   | (\ (   | (   ) |   | |   | |   | || (\ (   "
$fileh7 = "| )  \  || (____/\   | |   | )      | (____/\| )  \  || (____/\   | |   | ) \ \__| )   ( |   | |   | (___) || ) \ \__"
$fileh8 = "|/    )_)(_______/   )_(   |/       (_______/|/    )_)(_______/   )_(   |/   \__/|/     \|   )_(   (_______)|/   \__/"
$fileh9 = [System.String]::Concat("`n  STANDORT: ",((Get-WmiObject Win32_ComputerSystem).Domain), "`n`n")

# PENETRATION SESSION HEADDER
$penmaker = "_.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._`n"
$stringpenhead = [System.String]::Concat("HOST: ", $env:computername, "                                       ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n`n")
$extip = Invoke-RestMethod http://ipinfo.io/json | Select-Object -exp ip
$intip = ((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
$stringheadsession = ($penmaker, $stringpenhead, "IP-Adresse intern: ", $intip, "IP-Adresse extern: ", $extip, "`n`n")

#--- Funktionen ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Dauer Testdarstellungen
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

# Scriptheadder
function scripthead {

    # stringhost produzieren
    $stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
    ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $scriptname, " ]", "`n","`n") 
    $stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

    # Wenn Variable Null dann Screen leeren
    if (!$fmode) {
        Clear-Host
    }

    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "`n`n"

    Write-Host " _        _______ _________ _______  _______  _        _______ _________ _______  _______ _________ _______  _______ "
    Write-Host "( (    /|(  ____ \\__   __/(  ____ )(  ____ \( (    /|(  ____ \\__   __/(  ____ )(  ___  )\__   __/(  ___  )(  ____ )"
    Write-Host "|  \  ( || (    \/   ) (   | (    )|| (    \/|  \  ( || (    \/   ) (   | (    )|| (   ) |   ) (   | (   ) || (    )|"
    Write-Host "|   \ | || (__       | |   | (____)|| (__    |   \ | || (__       | |   | (____)|| (___) |   | |   | |   | || (____)|"
    Write-Host "| (\ \) ||  __)      | |   |  _____)|  __)   | (\ \) ||  __)      | |   |     __)|  ___  |   | |   | |   | ||     __)"
    Write-Host "| | \   || (         | |   | (      | (      | | \   || (         | |   | (\ (   | (   ) |   | |   | |   | || (\ (   "
    Write-Host "| )  \  || (____/\   | |   | )      | (____/\| )  \  || (____/\   | |   | ) \ \__| )   ( |   | |   | (___) || ) \ \__"
    Write-Host "|/    )_)(_______/   )_(   |/       (_______/|/    )_)(_______/   )_(   |/   \__/|/     \|   )_(   (_______)|/   \__/"

    Write-Host "`n"

}

# Speedtest
function netspeedtest ($penlocalfile, $penlocalfile2, $penexe) {
    
    if((Test-Path $penlocalfile -PathType leaf))                                                                                        # Wenn Datei  existiert, dann loeschen - lokale Tempfile 1
    {
        Remove-Item $penlocalfile
    }


    $speedt = & $penexe --format=json --accept-license --accept-gdpr                                                                    # Speedtest Paramerter
    $speedt | Out-File $penlocalfile -Force                                                                                             # Ausgabe in Tempfile 1
    
    $speedt = $speedt | ConvertFrom-Json                                                                                                # Tempfile 1 auslesen
    
    # Strings produzieren
    $logstringisp = [System.String]::Concat("ISP: ", $speedt.isp, "`n")
    $logstringping = [System.String]::Concat("Ping: ", $speedt.ping.latency, "`n")
    $logstringdown = [System.String]::Concat("DOWNLOAD: ", $speedt.download, "`n")
    $logstringupl = [System.String]::Concat("UPLOAD: ", $speedt.upload, "`n")
    
    $logstringfull = [System.String]::Concat("SPEEDTEST`n", $logstringisp, $logstringping, $logstringdown, $logstringupl, "`n")
    
    $logstringfull | Out-File -FilePath $penlocalfile2 -Append                                                                          # Tempfile 1 in Tempfile 2 schreiben

}

# Traffic Downloads
function fileloader ($trafficfile, $trafficlink1, $trafficlink2, $trafficlink3, $trafficlink4) {

    $randomload = Get-Random -Minimum 1 -Maximum 5                                                              # Randomgenerator 1 - 4

    # Randomlink festlegen
    if ($randomload -eq 4) {
        $trafficlink = $trafficlink4
    }elseif ($randomload -eq 3) {
        $trafficlink = $trafficlink3
    }elseif ($randomload -eq 2) {
        $trafficlink = $trafficlink2
    }elseif ($randomload -eq 1) {
        $trafficlink = $trafficlink1
    }

    if((Test-Path $trafficfile -PathType leaf))                                                                 # Wenn Datei  existiert, dann loeschen - Traffigfile
    {
        Remove-Item $trafficfile
    }
    
    $fileloader = New-Object System.Net.WebClient                                                               # Downloader erzeugen

    $stringlink = [System.String]::Concat("Link: ", $trafficlink)                                               # String Link produzieren
    $stringdlfile = [System.String]::Concat("Ziel: ", $trafficfile, "`n")                                       # String File produzieren

    "TRAFFIC GENERATOR`n" | Out-File -FilePath $penlocalfile2  -Append                                          # Headder in Tempfile 2 schreiben

    $stringlink | Out-File -FilePath $penlocalfile2  -Append                                                    # String Link in Tempfile 2 schreiben
    $stringdlfile | Out-File -FilePath $penlocalfile2 -Append                                                   # String File in Tempfile 2 schreiben
    $stringdlstart = [System.String]::Concat("Download Start: ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"))      # String Start produzieren
    $stringdlstart  | Out-File -FilePath $penlocalfile2 -Append                                                 # String Start in Tempfile 2 schreiben
    $fileloader.DownloadFile($trafficlink, $trafficfile)                                                        # Download Trafficfile
    $stringdlstop = [System.String]::Concat("Download Stop: ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"))        # String Stop produzieren
    $stringdlstop | Out-File -FilePath $penlocalfile2 -Append                                                   # String Stop in Tempfile 2 schreiben
    "`n" | Out-File -FilePath $penlocalfile2 -Append                                                            # Umbruch in Tempfile 2 schreiben

}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead                                                                              # Scriptheadder darstellen
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

scripthead                                                                              # Scriptheadder darstellen
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

if(!(Test-Path $penenv))                                                                # Wenn Ordner nicht vorhanden, dann erstellen - Workdirectory
{
    New-Item -Path $ENV:Temp -Name $penordner -ItemType "directory"
}

if(!(Test-Path $penexe -PathType leaf))                                                 # Wenn Datei nicht existiert, dann downloaden - Speedtest.exe
{
    $webClient = New-Object System.Net.WebClient
    $Webclient.DownloadFile($dlstl, $dlzip)

    Expand-Archive -LiteralPath $dlzip -DestinationPath $penenv
    Remove-Item $dlzip
}

if(!(Test-Path $penlog -PathType leaf))                                                 # Wenn Datei nicht existiert, dann erstellen - Logfile mit Headder
{
    New-Item $penlog
    $fileh0 | Out-File -FilePath $penlog
    $fileh1 | Out-File -FilePath $penlog -Append
    $fileh2 | Out-File -FilePath $penlog -Append
    $fileh3 | Out-File -FilePath $penlog -Append
    $fileh4 | Out-File -FilePath $penlog -Append
    $fileh5 | Out-File -FilePath $penlog -Append
    $fileh6 | Out-File -FilePath $penlog -Append
    $fileh7 | Out-File -FilePath $penlog -Append
    $fileh8 | Out-File -FilePath $penlog -Append
    $fileh9 | Out-File -FilePath $penlog -Append
}

if((Test-Path $penlocalfile2 -PathType leaf))                                           # Wenn Datei  existiert, dann loeschen und neu (leer) erstellen - Lokale Tempfile 2
{
    Remove-Item $penlocalfile2
    $stringheadsession | Out-File -FilePath $penlocalfile2
}else                                                                                   # Andernfalls erstellen
{
    $stringheadsession | Out-File -FilePath $penlocalfile2
}

scripthead                                                                              # Scriptheadder darstellen
Write-Host "   Vorbereitung abgeschlossen! `n   Beginne Net-Pentest...."                # Ausgabe
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

scripthead                                                                              # Scriptheadder darstellen
Write-Host "   Phase #1/4 `n   Speedtest...."                                           # Ausgabe
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

netspeedtest $penlocalfile $penlocalfile2 $penexe                                       # Speedtest Funktion aufrufen

scripthead                                                                              # Scriptheadder darstellen
Write-Host "   Phase #2/4 `n   Traffic erzeugen.... `n   Dowload #1/3"                  # Ausgabe
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

fileloader $trafficfile $trafficlink1 $trafficlink2 $trafficlink3 $trafficlink4         # Download 1

scripthead                                                                              # Scriptheadder darstellen
Write-Host "   Phase #2/4 `n   Traffic erzeugen.... `n   Dowload #2/3"                  # Ausgabe
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

fileloader $trafficfile $trafficlink1 $trafficlink2 $trafficlink3 $trafficlink4         # Download 2

scripthead                                                                              # Scriptheadder darstellen
Write-Host "   Phase #2/4 `n   Traffic erzeugen.... `n   Dowload #3/3"                  # Ausgabe
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

fileloader $trafficfile $trafficlink1 $trafficlink2 $trafficlink3 $trafficlink4         # Download 3

scripthead                                                                              # Scriptheadder darstellen
Write-Host "   Phase #3/4 `n   Erneuter Speedtest...."                                  # Ausgabe
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

netspeedtest $penlocalfile $penlocalfile2 $penexe                                       # Speedtest Funktion aufrufen

scripthead                                                                              # Scriptheadder darstellen
Write-Host "   Phase #4/4 `n   Log schreiben, Trash entfernen..."                       # Ausgabe
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

Get-Content -Path $penlocalfile2 | Out-File -FilePath $penlog -Append                   # Content von lokaler Tempfile in Logfile 


if (!$cleanmode)                                                                        # Tempfiles entfernen wenn aktiv
{
    Remove-Item -LiteralPath $penenv -Force -Recurse 
}

scripthead                                                                              # Scriptheadder darstellen
Write-Host "   ...Netzwerk Penetration abgeschlossen... `n    NetPenetrator :D :D"      # Ausgabe
waittimer $scriptspeed                                                                  # Scriptheadder darstellen

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID                                                                   # Shell schliessen
