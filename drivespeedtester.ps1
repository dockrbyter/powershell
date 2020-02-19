<#
drivespeedtester.ps1
.DESCRIPTION

    Ermittelt Lese / Schreib Geschwindigkeit von Laufwerken
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringdirvebenchmark1 = [System.String]::Concat("   Benchmark ", $driveletter, "...")

$laufwerke = Get-Volume

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Show-Menu
{
    param ([string]$Title = "Testen / Quit")
     
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $laufwerke.Basename -ForegroundColor Green


    Write-Host " "
	Write-Host " . . .  . . . . . . . . .  $Title  . . . . . . . . .   . . . `n" -ForegroundColor Cyan
    Write-Host "  1 > Laufwerk Benchmark"
    Write-Host " "
    Write-Host "  q > Quit `n"
    
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function drivespeedtester ($laufwerke) {
    
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $laufwerke -ForegroundColor Green
    
    $driveletter = Read-Host "   Welches Laufwerk soll gebenchmarkt werden?  BSP: c"
    
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringdirvebenchmark1
    
    winsat disk -seq -read -drive $driveletter
    winsat disk -seq -write -drive $driveletter

    Pause
    
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
do{
    Show-Menu
    $input = Read-Host " 1 / Q"
    switch ($input)
    {
       1 { drivespeedtester $laufwerke }      # Aktion Taste 1

    }
}
until ($input -eq 'q') 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

