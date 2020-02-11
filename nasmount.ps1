<#
nasmount.ps1

    Mountet Netzlaufwerke,
    sorgt durch geplante Task dafür, dass sinnloser Windowsfehler
    nicht ausgeloest wird.
    Task-Script wird nach Publich\Documents gespeichert.

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$smbadresse = "10.13.13.11"

$smbfreigabe1 = "Max"
        $smblocal1 = "H"
$smbfreigabe2 = "Media"
        $smblocal2 = "M"
$smbfreigabe3 = "Backup"
        $smblocal3 = "Z"

$taskhome = "$Env:USERPROFILE\Documents\git\powershell"
$taskscript = "netsharestarter.ps1"


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
"     [ ", $smbfreigabe3, " ]    ", $smblocal3, " --- ", $smbtest3, "`n", "`n",
"     [ ", $scriptjobname, " ]     Geplante Task --- ", $smbtesttask, "`n", "`n")

$smblocal1 = [System.String]::Concat($smblocal1, ":")
$smblocal1 = [System.String]::Concat($smblocal2, ":")
$smblocal1 = [System.String]::Concat($smblocal3, ":")

$smbshare1 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe1)
$smbshare2 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe2)
$smbshare3 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe3)

$scripttarget = "$taskhome\$taskscript"
$schedaction = New-ScheduledTaskAction "$pshome\powershell.exe" -Argument  "$scripttarget; quit"
$schedsettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
$schedtrigger = New-JobTrigger -AtLogOn
$scriptjobname = $taskscript.Replace(".ps1", "")

$smbtesterfolg = "Erfolgreich!"
$smbtestfail = "NICHT erfolgreich!"
$smbtest1 = $smbtestfail
$smbtest2 = $smbtestfail
$smbtest3 = $smbtestfail
$smbtesttask = $smbtestfail


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Fuehre mich auf jeden Fall als Admin aus!" -ForegroundColor DarkRed
Start-Sleep -Seconds 2

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringinterface

$smbcred = Get-Credential

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringmap
Start-Sleep -Seconds 3

New-PSDrive -Name $smblocal1 -PSProvider FileSystem -Root "$smbshare1" -Pers -Credential $smbcred -Scope Global
New-PSDrive -Name $smblocal2 -PSProvider FileSystem -Root "$smbshare2" -Pers -Credential $smbcred -Scope Global
New-PSDrive -Name $smblocal3 -PSProvider FileSystem -Root "$smbshare3" -Pers -Credential $smbcred -Scope Global

if (Test-Path $scripttarget -PathType leaf)     # Wenn Script vorahnden, dann...
{

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Erledigt! Zeit fuer eine geplante Task!"
    Write-Host " "
    Start-Sleep -Seconds 1.5

    Register-ScheduledTask -TaskName $scriptjobname -Action $schedaction -Trigger $schedtrigger -RunLevel Highest -User 'Users' -Settings $schedsettings    # Neue Task erstellen

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Task erstellt!"
    Write-Host "   Bei jedem Login wird sichergestellt, dass die Netzlaufwerke verfuegbar sind."
    Write-Host " "
    Start-Sleep -Seconds 1.5

}
else    # ...wenn nicht, dann...
{
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   netsharestarter.sp1 nicht gefunden!" -ForegroundColor DarkRed
    Write-Host " "
    Start-Sleep -Seconds 1.5
}

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Pruefe kurz meine Arbeit..."
Start-Sleep -Seconds 1.5

if ( Test-Path -Path $smblocal1 -PathType Container ) { $smbtest1 = $smbtesterfolg }                # Checke SMB-Share 1
if ( Test-Path -Path $smblocal2 -PathType Container ) { $smbtest2 = $smbtesterfolg }                # Checke SMB-Share 2
if ( Test-Path -Path $smblocal3 -PathType Container ) { $smbtest3 = $smbtesterfolg }                # Checke SMB-Share 3

if ( Get-ScheduledTask $scriptjobname -ErrorAction Ignore ) { $smbtesttask = $smbtesterfolg }       # Checke geplante Task

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringeval
Start-Sleep -Seconds 4

