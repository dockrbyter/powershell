<#
botcleaner.ps1
.DESCRIPTION

    Script-Vorlage
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$scriptspeed = "2"                          # Darstellungsdauer der Textausgaben in Sekunden            EX  2

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "    Augenblick! Einmal kurz den Desktop desinfizieren..."
waittimer

Stop-Process -Name *Firefox*
Start-Sleep -Seconds 1
Stop-Process -Name *Excel*
Start-Sleep -Seconds 1
Stop-Process -Name *deepl*

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "    Alles klar, es kann weiter gehen..."
waittimer


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID       # Shell schliessen

