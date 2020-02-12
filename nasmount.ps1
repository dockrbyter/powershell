<#
nasmount.ps1

    Mountet Netzlaufwerke,
    sorgt durch geplante Task dafür, dass sinnloser Windowsfehler
    nicht ausgeloest wird.
    Task-Script wird nach Publich\Documents gespeichert.

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$smbadresse = "10.13.13.11"     # Adresse des Net-Shares

$smbfreigabe1 = "Max"           # Name Freigabe 1
        $smblocal1 = "H"        # Buchstabe Freigabe 1
$smbfreigabe2 = "Media"         # Name Freigabe 2
        $smblocal2 = "M"        # Buchstabe Freigabe 2
$smbfreigabe3 = "Backup"        # Name Freigabe 3
        $smblocal3 = "Z"        # Buchstabe Freigabe 3


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " @ Windows 10: ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n")

$stringinterface = [System.String]::Concat("   Credentials fuer ", $smbadresse, " benoetigt!", "`n", "`n")
$stringmap = [System.String]::Concat("   Folgende Netzwerkspeicher werden gemapt:", "`n",
"   [ ", $smbfreigabe1, " ]  ", $smblocal1, "`n",
"   [ ", $smbfreigabe2, " ]  ", $smblocal2, "`n",
"   [ ", $smbfreigabe3, " ]  ", $smblocal3, "`n")
$stringeval = [System.String]::Concat("       Auswertung:", "`n",
"     [ ", $smbfreigabe1, " ]    ", $smblocal1, " --- ", $smbtest1, "`n",
"     [ ", $smbfreigabe2, " ]    ", $smblocal2, " --- ", $smbtest2, "`n",
"     [ ", $smbfreigabe3, " ]    ", $smblocal3, " --- ", $smbtest3, "`n", "`n")

$smbshare1 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe1)
$smbshare2 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe2)
$smbshare3 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe3)

$smblocaldrive1 = [System.String]::Concat($smblocal1, ":")
$smblocaldrive2 = [System.String]::Concat($smblocal2, ":")
$smblocaldrive3 = [System.String]::Concat($smblocal3, ":")

$smbtesterfolg = "Erfolgreich!"
$smbtestfail = "NICHT erfolgreich!"
$smbtest1 = $smbtestfail
$smbtest2 = $smbtestfail
$smbtest3 = $smbtestfail


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringinterface

$smbcred = Get-Credential

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringmap
Start-Sleep -Seconds 2

New-PSDrive -Name $smblocal1 -Root "$smbshare1" -Persist -PSProvider FileSystem -Scope 'Global' -Credential $smbcred    # Mapping Share 1
New-PSDrive -Name $smblocal2 -Root "$smbshare2" -Persist -PSProvider FileSystem -Scope 'Global' -Credential $smbcred    # Mapping Share 2
New-PSDrive -Name $smblocal3 -Root "$smbshare3" -Persist -PSProvider FileSystem -Scope 'Global' -Credential $smbcred    # Mapping Share 3

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   ... Warte auf Windows, pruefe kurz meine Arbeit..."
Start-Sleep -Seconds 5

if ( Test-Path -Path $smblocaldrive1 -PathType Container ) { $smbtest1 = $smbtesterfolg }                # Checke Share 1
if ( Test-Path -Path $smblocaldrive2 -PathType Container ) { $smbtest2 = $smbtesterfolg }                # Checke hare 2
if ( Test-Path -Path $smblocaldrive3 -PathType Container ) { $smbtest3 = $smbtesterfolg }                # Checke Share 3

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringeval
Start-Sleep -Seconds 4

