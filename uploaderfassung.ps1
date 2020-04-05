<#
Uploaderfassung.ps1
.DESCRIPTION

    Erfasst Ordnerinhalt in CSV
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$quellverzeichnis = "D:\Upload"
$zielverzeichnis = $quellverzeichnis

$csvdatei = "upload.csv"


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

$stringerfassung = [System.String]::Concat("   Erfassung erledigt!   ", "`n", $zielpfad, "`n", "   Beginne mit Nachbearbeitung...", "`n")

$exclude = @(".cs", ".tt", ".xaml", ".csproj", ".sln", ".xml", ".cmd", ".txt", ".ps1, ", ".ps1, ")
$quelle = "$quellverzeichnis\*.*"
$zielpfad = "$zielverzeichnis\$csvdatei"

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Erfassung ---

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Beginne Erfassung..."
Start-Sleep -Seconds 1.5


If(!(test-path $zielpfad))
{
      New-Item -ItemType Directory -Force -Path $path
      New-Item -Path $zielpfad -Name $$csvdatei -ItemType "file" -Value "Uploaderfassung"
}


Get-ChildItem $quelle -Exclude $exclude | Select-Object FullName | Out-File $zielpfad -Append -Encoding Unicode

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringerfassung
Start-Sleep -Seconds 2


#--- Nachbearbeitung ---





