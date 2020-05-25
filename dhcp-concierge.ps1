<#
dhcp-concierge.ps1
.DESCRIPTION

    Erstellt DHCP-Bereiche anahnd einer CSV-Datei
    und ordnet Clients anhand einer weiteren CSV-Datei
    den ensprechenden Bereichen zu. 
    Drucker- und Rest-Bereich bitte NICHT inder CSV angeben!
    Einstellungen hierfuer bitte in Variablen vornehmen.
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$poolcsv = ("$PSScriptRoot\pool.csv")       # Raum-CSV-Datei                                            EX  C:\dhcp\pool.csv
$clientcsv = ("$PSScriptRoot\clients.csv")  # Client-CSV-Datei                                          EX  C:\dhcp\clients.csv

$dchpServer = ""                            # Hostname des DHCP-Servers                                 EX  DCHPSRV01

$domainname = ""                            # Domain-Name                                               EX  standort01
$domainsuffix = ""                          # Domain-Suffix                                             EX  local

$ippref = "10.10"                           # Erstes Oktet der IP-Range                                 EX  192.168
$iprangestart = "100"                       # Erste IP-Adresse eines Pools                              EX  100
$iprangeend = "200"                         # Letzte IP-Adresse eines Pools                             EX  200
$sunbnetmask = "255.255.0.0"                # Subnetmaks                                                EX  255.255.0.0

$raumcount = "99"                           # Startbereich der automatischen Bereichserstellund (-1)    EX  99 -wenn erster erstellter Bereich 100 sein soll
$printerpool = "Drucker"                    # Bereichsbezeichnung fuer Durcker                          EX  Drucker
$printerrange = "30"                        # Breich fuer Drucker                                       EX  30
$restpool = "Sonstige"                      # Bereich fuer Geraete die nicht zugeordnet werden koennen  EX  Sonstige
$restrange = "200"                          # Breich fuer Sonstige Geraete                              EX  200

$scriptspeed = "2"                          # Darstellungsdauer der Textausgaben in Sekunden            EX  2

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringtitle = "`n* * *              * * *`n     DHCP-Concierge     `n* * *              * * *`n"

$dhcpsrv = ("$dchpServer.$domainname.$domainsuffix")

$printerrangestart = ("$ippref.$printerrange.$iprangestart")
$printerrangeend = ("$ippref.$printerrange.$iprangeend")

$restrangestart = ("$ippref.$restrange.$iprangestart")
$restrangeend = ("$ippref.$restrange.$iprangeend")

$headraum = "Raeume"
$headScopeId = "ScopeId"
$headclientname = "Name"
$headclientmac = "ClientId"
$headfull =   @("$headScopeId,$headclientname,$headclientmac")

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Datei-Checks -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringtitle
waittimer

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringtitle
Write-Host "`n   Suche nach CSV-Dateien...`n"
waittimer

# Raum-CSV checken und bei Bedarf erstellen
if (!(Test-Path $poolcsv)) {
    
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringtitle
    Write-Host "`n   Raum-CSV-Datei nicht gefunden! `n   Erstelle Datei...`n"
    waittimer

    Add-Content -Path $poolcsv -Value $headraum

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringtitle
    Write-Host "`n   Raum-CSV-Datei erstellt! `n   Bitte befuellen und Script neu starten.`n"
    waittimer

    stop-process -Id $PID       # Shell schliessen

}

# Client-CSV checken und bei Bedarf erstellen
if (!(Test-Path $clientcsv)) {
    
    $stringheaderinfo = [System.String]::Concat("`n   ", $headScopeId, " = Raumname`n   ", $headclientname, " = Client-Host-Name`n   ", $headclientmac, " = CLient-MAC-Adresse`n`n")

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringtitle
    Write-Host "`n   Client-CSV-Datei nicht gefunden! `n   Erstelle Datei...`n"
    waittimer

    Add-Content -Path $clientcsv -Value $headfull

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringtitle
    Write-Host "`n   Client-CSV-Datei erstellt! `n   Bitte befuellen und Script neu starten.`n"
    Write-Host $stringheaderinfo
    waittimer

    stop-process -Id $PID       # Shell schliessen

}


#--- DHCP Pools erstellen -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringtitle
Write-Host "`n   Beginne mit Raumerstellung...`n"
waittimer

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringtitle
Write-Host "`n   Erstelle Drucker-Bereich...`n"
waittimer

Add-DhcpServerv4Scope -ComputerName $dhcpsrv -Name $printerpool -StartRange $printerrangestart -EndRange $printerrangeend -SubnetMask $sunbnetmask -Description $printerpool

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringtitle
Write-Host "`n   ...erledigt! Erstelle Sonstigen-Bereich...`n"
waittimer

Add-DhcpServerv4Scope -ComputerName $dhcpsrv -Name $restpool -StartRange $restrangestart -EndRange $restrangeend -SubnetMask $sunbnetmask -Description $printerpool

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringtitle
Write-Host "`n   ...erledigt! Beginne mit CSV-Verarbeitung...`n"
waittimer

Import-Csv -Path $poolcsv -Header $headraum |  Foreach-Object{
    $raumcount++
    $stringcurrent = [System.String]::Concat("`n   DHCP-Pool ", $_.Raeume, "`n   Range von: ", $raumSTARTrange, " bis ", $raumENDrange, "`n")
    
    $raumSTARTrange = [System.String]::Concat("$ippref.$raumcount.$iprangestart")
    $raumENDrange = [System.String]::Concat("$ippref.$raumcount.$iprangeend")
    
    Add-DhcpServerv4Scope -ComputerName $dhcpsrv -Name $_.Raeume -StartRange $raumSTARTrange -EndRange $raumENDrange -SubnetMask $sunbnetmask -Description $_.Raeume

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringtitle
    Write-Host $stringcurrent
    waittimer
    }


#--- Clients den Pools zuweisen -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringtitle
Write-Host "`n   Ich zeige nun unseren Gaesten ihre Zimmer...`n   (Ordne Clients DHCP-Bereichen)`n"
waittimer

Import-Csv -Path $clientcsv -Header $headraum  | Add-DhcpServerv4Scope -ComputerName $dhcpsrv -State Active

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringtitle
Write-Host "`n   Unsere Gaeste befinden sich nun auf ihren Zimmern.`n   (Bereichszuordnung abgeschlossen)`n"
waittimer

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID       # Shell schliessen

