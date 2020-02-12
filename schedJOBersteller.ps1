<#
taskersteller.ps1

    Erstellt geplante Jobs fuer Scripts

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$taskhome = "$Env:USERPROFILE\Documents\git\powershell"
$taskscript = "netsharestarter.ps1"

$scripttarget = "$taskhome\$taskscript"
$schedoptions = (New-ScheduledJobOption -RequireNetwork -ContinueIfGoingOnBattery -StartIfOnBattery)
$schedtrigger = (New-JobTrigger -AtLogOn)
$scriptjobname = $taskscript.Replace(".ps1", "")


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")
$string1 = [System.String]::Concat("   Erstelle Job ", $scriptjobname, "`n", "`n")
$string2 = [System.String]::Concat("   Joberstellung: ", $jobtest, " !", "`n", "`n")

$jobtesterfolg = "Erfolgreich"
$jobtestfail = "NICHT erfolgreich"
$jobtest = $jobtestfail

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "      FUEHRE MICH ALS ADMIN AUS!" -ForegroundColor DarkRed
Start-Sleep -Seconds 2

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $string1
Start-Sleep -Seconds 2

Register-ScheduledJob -Name $scriptjobname -FilePath $scripttarget -ScheduledJobOption $schedoptions -Trigger $schedtrigger     # Erstelle geplanten Job

if ( Get-ScheduledTask $scriptjobname -ErrorAction Ignore ) { $jobtest = $jobtesterfolg }       # Checke geplanten Job

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $string2
Start-Sleep -Seconds 4

