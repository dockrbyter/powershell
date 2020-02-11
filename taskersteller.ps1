<#
taskersteller.ps1

    Erstellt geplante Tasks fuer Scripts

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$taskuser ="*"

$taskhome = "$Env:USERPROFILE\Documents\git\powershell"
$taskscript = "netsharestarter.ps1"

$scripttarget = "$taskhome\$taskscript"
$schedaction = New-ScheduledTaskAction "$pshome\powershell.exe" -Argument  "$scripttarget; quit"
$schedsettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
$schedtrigger = New-JobTrigger -AtLogOn
$scriptjobname = $taskscript.Replace(".ps1", "")


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Start-Sleep -Seconds 1

Register-ScheduledTask -TaskName $scriptjobname -Action $schedaction -Trigger $schedtrigger -RunLevel Highest -User $taskuser -Settings $schedsettings    # Neue Task erstellen




if ( Get-ScheduledTask $scriptjobname -ErrorAction Ignore ) { $smbtesttask = $smbtesterfolg }       # Checke geplante Task

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Write-Host $smbtesttask


