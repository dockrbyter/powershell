<#
MUM.ps1
.DESCRIPTION

    MUM - MAC User Merge
	
	Bindet MAC-Adressen an AD-User zwecks RADIUS-Authentifizierung
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$zielhostname = "maexicodc"                                                         # Hostname von Zielserver                               EX megadc

$scriptspeed = "2"                                                                  # Darstellungsdauer der Textausgaben in Sekunden        EX  2
$fmode = ""                                                                        	# Floating Mode (fuer Debugging)                        EX  x

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$scriptname = $MyInvocation.MyCommand.Name
$stringmenuad1 = "     Taste 1 fuer MAC - User - Merge"

$Host.UI.RawUI.ForegroundColor = 'Green'                                            # Script Textfarbe

#--- Funktionen ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Textgeschwindigkeit
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

# Script-Titel
function scripthead {

    $stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
    ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $scriptname, " ]", "`n","`n") 
    $stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

    if (!$fmode) {
        Clear-Host
    }

    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "`n`n"

    Write-Host "   MUM - MAC User Merge"
    
    Write-Host "`n"

}

# MAC User Merge
function mumtask {
    
    scripthead
    $user = Read-Host "Anmeldename des zu bearbeitenden Benutzers eingeben?"

    scripthead
    $macadr1 = Read-Host "MAC-Adresse Zeichenpaar 1?"
    $macadr2 = Read-Host "MAC-Adresse Zeichenpaar 2?"
    $macadr3 = Read-Host "MAC-Adresse Zeichenpaar 3?"
    $macadr4 = Read-Host "MAC-Adresse Zeichenpaar 4?"
    $macadr5 = Read-Host "MAC-Adresse Zeichenpaar 5?"
    $macadr6 = Read-Host "MAC-Adresse Zeichenpaar 6?"

    $macadr = [System.String]::Concat($macadr1, "-", $macadr2, "-", $macadr3, "-", $macadr4, "-", $macadr5,  "-", $macadr6)

    Write-Host "     Bearbeite User..." -ForegroundColor Yellow
    Invoke-Command -computername $zielhostname -ScriptBlock{
		Get-ADUser $args[0] | Set-ADUser -Replace @{msNPCallingStationID=$args[1]}
	} -ArgumentList $user, $macadr

    scripthead
    Write-Host "Erledigt!" -ForegroundColor Yellow
    waittimer
    
}

# Menu einblenden
function Show-MenuAD
{
    param ([string]$Title = "     Hauptmenu")

    scripthead
    Write-Host $stringmenuad1
    Write-Host "     Taste Q zum Beenden"
    Write-Host "`n------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead
waittimer

# Menu aufrufen und offen halten
do{

    Show-MenuAD
    $input = Read-Host "MAC-Adressen Usern zuweisen?"
    switch ($input)
    {
       1 { mumtask }       # Aktion Taste 1 - MUM

    }
}
until ($input -eq 'q') 

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$Host.UI.RawUI.BackgroundColor = 'Gray'           # Script Hintergrundfarbe
$Host.UI.RawUI.ForegroundColor = 'Blue'          	# Script Textfarbe

scripthead
waittimer

stop-process -Id $PID       						# Shell schliessen
