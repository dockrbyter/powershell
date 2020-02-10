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




#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " @ Windows 10: ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n")

$stringinterface = [System.String]::Concat("   Credentials fuer ", $smbadresse, " benoetigt!", "`n", "`n")
$stringmap = [System.String]::Concat("   Folgende Netzwerkspeicher werden gemapt:", "`n",
"   [ ", $smbfreigabe1, " ]  ", $smblocal1, ":", "`n",
"   [ ", $smbfreigabe2, " ]  ", $smblocal2, ":", "`n",
"   [ ", $smbfreigabe3, " ]  ", $smblocal3, ":", "`n")

$smbshare1 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe1)
$smbshare2 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe2)
$smbshare3 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe3)


$taskhome = "$Env:PUBLIC\Docuemnts"
$taskscript = "netsharestarter.ps1"
$scriptjobname = ($taskscript -replace ".{4}$")
$scripttarget = "$taskhome\$taskscript"
$taskscriptcontent = [System.String]::Concat(
        "$i=3 while($True){ $error.clear() $MappedDrives = Get-SmbMapping | Where-Object -property Status -Value Unavailable -EQ | Select-Object LocalPath,RemotePath foreach( $MappedDrive in $MappedDrives)
            {
                try {
                    New-SmbMapping -LocalPath $MappedDrive.LocalPath -RemotePath $MappedDrive.RemotePath -Persistent $True
                } catch {
                    Write-Host "There was an error mapping $MappedDrive.RemotePath to $MappedDrive.LocalPath"
                }
            }
            $i = $i - 1
            if($error.Count -eq 0 -Or $i -eq 0) {break}
        
            Start-Sleep -Seconds 30
        
        }")
    
$schedaction = New-ScheduledTaskAction "$pshome\powershell.exe" -Argument  "$scripttarget; quit"
$schedsettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
$schedtrigger = New-JobTrigger -AtLogOn


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringinterface

$smbcred = Get-Credential

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringmap
Start-Sleep -Seconds 3


New-PSDrive -Name $smblocal1 -PSProvider FileSystem -Root "$smbshare1" -Persist -Credential $smbcred -Scope Global
New-PSDrive -Name $smblocal2 -PSProvider FileSystem -Root "$smbshare2" -Persist -Credential $smbcred -Scope Global
New-PSDrive -Name $smblocal3 -PSProvider FileSystem -Root "$smbshare3" -Persist -Credential $smbcred -Scope Global

Write-Host "   ...Ok, wenn alles gut aussieht, druecke Enter, damit es weiter geht."
    Pause

<#
Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   ...das haetten wir."
Write-Host "   Erstelle Script fuer geplante Task..."
Start-Sleep -Seconds 1.5

Set-Content -Path $scripttarget -Value $taskscriptcontent
pause

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
Write-Host "   Das wars..."
Start-Sleep -Seconds 1.5

#>