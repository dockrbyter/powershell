<#
.SYNOPSIS
    Erstellt SSH-Keys
.DESCRIPTION
    Edit SETTINGS-Block!

    $scriptspeed - Darstellungsdauer - Nur bei Bedarf editieren
    $fmode - Floating Mode - Nur bei Bedarf editieren

    Alle weiteren Variablen koennen leer gelassen werden, da das Script die Werte interaktiv abfragt.

.EXAMPLE
    PS> .\sshkeydude.ps1
.LINK
    https://raw.githubusercontent.com/thelamescriptkiddiemax/powershell/master/11aa_VORLAGE.ps1
#>
#--- SETTINGS -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$nuob = ""                                          # Anzahl der Bits im zu erstellenden Keys
$algt = ""                                          # Algorithmus zum Erstellen des Keys
$kname = ""                                         # Dateiname des zu erstellenden Keys

[double]$scriptspeed = 2                            # Timespan to show text in seconds                      e.g.    2
$fmode = ""                                        # Floating Mode (for debugging)                         e.g.    x

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
    Write-Host "    ___  ___  _   _  _  _  ____  _  _  ____  __  __  ____  ____ " -ForegroundColor DarkCyan
    Write-Host "   / __)/ __)( )_( )( )/ )( ___)( \/ )(  _ \(  )(  )(  _ \( ___)" -ForegroundColor DarkCyan
    Write-Host "   \__ \\__ \ ) _ (  )  (  )__)  \  /  )(_) ))(__)(  )(_) ))__) " -ForegroundColor DarkCyan
    Write-Host "   (___/(___/(_) (_)(_)\_)(____) (__) (____/(______)(____/(____)" -ForegroundColor DarkCyan
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

# Wenn $algt NULL...
if (!$algt) {
    scripthead
    $algt = Read-Host -Prompt "   Welcher Algorithmus soll zum Erstellen verwendet werden? (rsa, dsa, ecdsa, ed25519) [Enter fuer Default-Wert (rsa)]"        # Erfrage Algorithmus
    
    # Wenn $algt NULL...
    if (!$algt) {
        $algt = "rsa"         # $algt = Algorithmus zum Erstellen des Keys
    }
}

# Wenn $nuob NULL...
if (!$nuob) {
    scripthead
    $nuob = Read-Host -Prompt "   Anzahl der Bits im zu erstellenden Key? [Enter fuer Default-Wert (4096)]"        # Erfrage Anzahl Bits
    
    # Wenn $nuob NULL...
    if (!$nuob) {
        $nuob = 4096         # $nuob = Anzahl der Bits im zu erstellenden Key
    }
}

$tringkname = [System.String]::Concat("SSH-Key_",(Get-WmiObject Win32_ComputerSystem).Domain, "_", $env:UserName)

# Wenn $kname NULL...
if (!$kname) {
    scripthead
    $kname = Read-Host -Prompt "   Dateiname des zu erstellenden Keys? [Enter fuer Default-Wert ($tringkname)]"        # Dateiname
    
    # Wenn $kname NULL...
    if (!$kname) {
        $kname = $tringkname         # $kname = Dateiname des zu erstellenden Keys
    }
}

scripthead
Write-Host "Erstelle Key..."
scriptspeed $scriptspeed

$keypath = [System.String]::Concat($env:USERPROFILE, "/.ssh/", $kname)

ssh-keygen -t $algt -b $nuob -f $keypath

scriptspeed $scriptspeed

$pubkey = [System.String]::Concat($keypath, ".pub")
notepad.exe $pubkey

scripthead
Write-Host "   SSH-Key erstellt! `n Wie Ihnen sicher aufgefallen ist, wurde der soeben erstellte Key in Notepad geoeffnet. Kopieren Sie den gesamten Dateiinhalt in Ihr Clipboard. `n Oeffnen Sie anschliessend eine SSH-Verbindung zu Ihrem Zielsystem und fuehren den folgenden Befehl aus:"
Write-Host "sudo nano .ssh/authorized_keys" -ForegroundColor Yellow
Write-Host "Fuegen Sie nun den Inhalt aus Ihrem Clipboard in die Datei ein. Druecken Sie 'Strg X' und bestaetigen Sie die Meldung, um die Datei zu schliessen und die Aenderungen zu speichern."
Write-Host "Stellen Sie unbedingt sicher, dass der private Teil des Keys nicht in fremde Haende geraet! Ein Backup z.B. in Keepass wird empfohlen!" -ForegroundColor DarkRed
Pause
