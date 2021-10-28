<#
inventoryscripty.ps1
.DESCRIPTION
    Uebungs-Inventarisierungs-Script

    Das Script erfasst folgende Daten (automatisiert):
    - Domain
    - Raumbezeichnung *
    - Hostname
    - Windows Variante
    - Windows Version
    - RAM in GB
    - Festplatte in GB
    - Festplattentyp
    - Medientyp (HDD / SSD) **
    - CPU
    - Mainboard Serial

    (manuell)
    - WS-Typ (LuL, SuS, Sonstiges)


    Die erfassten Daten werden in einer CSV-Datei gespeichert, welche im Speicherort des Scriptes generiert wird.
    Zur Ausfuehrung werden administrative Rechte benoetigt!
    Eventuelle Hostname-Prefixe koennen durch das Setzen eines Wertes in $prefix entfert werden.



    *   Das Script geht davon aus, dass die Raumbezeichnung die ersten 4 Zeichen des Hostnamens sind
    **  Je nach Hardware-Konfiguration kann es vorkommen, dass der Medientyp nicht ordnungsgemaes erfasst wird

#>
#--- Settings ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$csvname = "inventar"               # Name der CSV-Datei                                            EX  inventar
$prefix = "X"                       # Prefix des Hostnames                                          EX  LE-NB                

$scriptspeed = 2                    # Darstellungsdauer der Textausgaben in Sekunden                EX  2
$fmode = ""                         # Floating Mode (fuer Debugging)                                EX  x

#--- Variablen ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$sourcefolder = $PWD.Path
$csvvorlage = [System.String]::Concat($sourcefolder, "\", $csvname, ".csv")

$scriptname = $MyInvocation.MyCommand.Name

$prop1 = "Domain"
$prop2 = "Raum"
$prop3 = "Hostname"
$prop4 = "OS"
$prop5 = "OS Version"
$prop6 = "OU"
$prop7 = "RAM"
$prop8 = "Festplattengroesse"
$prop9 = "Festplattentyp"
$prop10 = "Medientyp"
$prop11 = "CPU"
$prop12 = "MB Serial"

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

    Write-Host "   _________ _                 _______  _       _________ _______  _______           _______  _______  _______ _________ _______ _________         " -ForegroundColor Blue
    Write-Host "   \__   __/( (    /||\     /|(  ____ \( (    /|\__   __/(  ___  )(  ____ )|\     /|(  ____ \(  ____ \(  ____ )\__   __/(  ____ )\__   __/|\     /|" -ForegroundColor Blue
    Write-Host "      ) (   |  \  ( || )   ( || (    \/|  \  ( |   ) (   | (   ) || (    )|( \   / )| (    \/| (    \/| (    )|   ) (   | (    )|   ) (   ( \   / )" -ForegroundColor Blue
    Write-Host "      | |   |   \ | || |   | || (__    |   \ | |   | |   | |   | || (____)| \ (_) / | (_____ | |      | (____)|   | |   | (____)|   | |    \ (_) / " -ForegroundColor Blue
    Write-Host "      | |   | (\ \) |( (   ) )|  __)   | (\ \) |   | |   | |   | ||     __)  \   /  (_____  )| |      |     __)   | |   |  _____)   | |     \   /  " -ForegroundColor Blue
    Write-Host "      | |   | | \   | \ \_/ / | (      | | \   |   | |   | |   | || (\ (      ) (         ) || |      | (\ (      | |   | (         | |      ) (   " -ForegroundColor Blue
    Write-Host "   ___) (___| )  \  |  \   /  | (____/\| )  \  |   | |   | (___) || ) \ \__   | |   /\____) || (____/\| ) \ \_____) (___| )         | |      | |   " -ForegroundColor Blue
    Write-Host "   \_______/|/    )_)   \_/   (_______/|/    )_)   )_(   (_______)|/   \__/   \_/   \_______)(_______/|/   \__/\_______/|/          )_(      \_/   " -ForegroundColor Blue                                                                                                                         

    Write-Host "`n"

}

# Dauer Einblendungen
function scriptspeed ($scriptspeed)
{
    Start-Sleep -Seconds $scriptspeed                                                                                                               # display timeout
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead

scripthead
Write-Host "   Beginne Erfassung" -ForegroundColor Yellow
scriptspeed $scriptspeed

# Domain Erfassung
$1dom = ((Get-WmiObject Win32_ComputerSystem).Domain)

# Raum Variable erstellen
$2raum = $env:computername
$2raum = $2raum.replace($prefix," ")
$2raum = $2raum.SubString(0,4)

# Hostname Variable erstellen
$3host = $env:computername

# OS ermitteln
$4os = (Get-CimInstance Win32_OperatingSystem).Caption

# OS Version ermitteln
$5osvers = ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId)

# Lehrer oder Schüler Client
$confirmation1 = Read-Host "   Ist der aktuelle Host eine LuL-WS, eine SuS-WS, oder etwas Sonstiges? [1 LuL / 2 SuS / 3 Sonstiges]"
if ($confirmation1 -eq '1') {
    $6domou = "LuL-WS"
}elseif ($confirmation1 -eq '2') {
    $6domou = "SuS-WS"
}else {
    $6domou = "Sonstiges"
}

# Wie viel RAM in GB
$7ram = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb

# Wie groß ist meine Festplatte
$8hddgb = ("{0}GB total" -f [math]::truncate($disk.Size / 1GB))

# Name von Festplatte
$9typ = Get-PhysicalDisk | ForEach-Object -Process {$_.FriendlyName} -ErrorAction SilentlyContinue

# Welcher Medientyp
$10medientyp = Get-PhysicalDisk | ForEach-Object -Process {$_.Mediatype} -ErrorAction SilentlyContinue

# Was ist das für ein CPU
$11cpu = (Get-WmiObject Win32_Processor).Name

# Seriennummer Mainboard
$12mbserial = (Get-WmiObject win32_baseboard).SerialNumber

scripthead
Write-Host "   Erfassung abgeschlossen, exportiere Daten in CSV..." -ForegroundColor Yellow
scriptspeed $scriptspeed

$newrow = New-Object PSObject -Property @{
    $prop1 = $1dom
    $prop2 = $2raum
    $prop3 = $3host
    $prop4 = $4os
    $prop5 = $5osvers
    $prop6 = $6domou
    $prop7 = $7ram
    $prop8 = $8hddgb
    $prop9 = $9typ
    $prop10 = $10medientyp
    $prop11 = $11cpu
    $prop12 = $12mbserial
}

$newrow | Select-Object $prop1, $prop2, $prop3, $prop4, $prop5, $prop6, $prop7, $prop8, $prop9, $prop10, $prop11, $prop12 | Export-Csv $csvvorlage -Append -NoTypeInformation -Delimiter ";"

scripthead
Write-Host "   ...Daten-Export abgeschlossen!" -ForegroundColor Yellow
scriptspeed $scriptspeed

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
