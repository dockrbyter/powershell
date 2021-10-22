<#
.SYNOPSIS
    Vorlage fuer andere Scripte
.DESCRIPTION
    Edit SETTINGS-Block!

    $scriptspeed - Darstellungsdauer - Nur bei Bedarf editieren
    $fmode - Floating Mode - Nur bei Bedarf editieren

.EXAMPLE
    PS> .\VORLAGE.ps1
.LINK
    https://github.com/thelamescriptkiddiemax/powershell/blob/master/11aa_VORLAGE.ps1.ps1
#>
#--- Variables ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


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
    Write-Host "   Titel" -ForegroundColor DarkCyan
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

