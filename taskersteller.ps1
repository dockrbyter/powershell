<#
taskersteller.ps1

    Erstellt geplante Tasks fuer Scripts

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$taskuser = "*"

$taskhome = "$Env:USERPROFILE\Documents\git\powershell"
$taskscript = "netsharestarter.ps1"

$scripttarget = "$taskhome\$taskscript"
$schedaction = New-ScheduledTaskAction "$pshome\powershell.exe" -Argument  "$scripttarget; quit"
$schedoptions = (New-ScheduledJobOption -RequireNetwork -ContinueIfGoingOnBattery -StartIfOnBattery)
$schedtrigger = (New-JobTrigger -AtLogOn)
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

#Register-ScheduledTask -TaskName $scriptjobname -Action $schedaction -Trigger $schedtrigger -RunLevel Highest -User $taskuser -Settings $schedsettings    # Neue Task erstellen

Register-ScheduledJob -Name $scriptjobname -FilePath $scripttarget -ScheduledJobOption $schedoptions -Trigger $schedtrigger

#$O = New-ScheduledJobOption -WakeToRun -StartIfIdle -MultipleInstancePolicy Queue
#$T = New-JobTrigger -Weekly -At "9:00 PM" -DaysOfWeek Monday -WeeksInterval 2
#$path = "\\Srv01\Scripts\UpdateVersion.ps1"








if ( Get-ScheduledTask $scriptjobname -ErrorAction Ignore ) { $smbtesttask = $smbtesterfolg }       # Checke geplante Task

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Write-Host $smbtesttask


