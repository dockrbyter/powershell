<#
gutenmorgen.ps1
.DESCRIPTION

    Sichert XLSX-Dateien, loescht TMP-Dateien
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$quellDIR = ""          # Specherort XLSX-Dateien   EX C:\stuff\stuff
$zielDIR = ""           # Specherort Backup         EX C:\stuff\backup


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringgutenmorgen = [System.String]::Concat("`n   Guten Morgen", $env:UserName, "! `n   Fangen wir an...`n")
$stringbackup = [System.String]::Concat("`n   Starte Backup`n`n   Copiere XLSX-Dateien von `n ", $quellDIR, "`n   nach `n", $zielDIR, "`n`n")

$quelle = ("$quellDIR\*.xlsx")
$tempfiles = ("$quellDIR\*.tmp")


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringgutenmorgen
Start-Sleep -Seconds 2

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringbackup
Start-Sleep -Seconds 2

Copy-Item -Path $quelle -Destination $zielDIR | Out-Null

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "`n   Erledigt! Entferne TMP-Dateien...`n"
Start-Sleep -Seconds 2

Remove-Item $tempfiles | Out-Null

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "`n   Erledigt! Entferne TMP-Dateien...`n"
Start-Sleep -Seconds 2


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID       # Shell schliessen

