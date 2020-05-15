<#
sheetcompare.ps1
.DESCRIPTION

    Vergleicht 2 XLSX-Dateien
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$xlsxpath = $PSScriptRoot       # Pfad zu XLSX-Dateien                                      EX C:\stuff\morestuff\
$xlsxMaster = "Master"          # Dateiname XLSX Referenz-Datei                             EX TolleListe
$xlsxdiff = "Diff"              # Dateiname XLSX Differenz-Datei                            EX AuchGuteListe
$sheetname = "Tabelle1"         # Sheet-Name - Muss bei beiden Dateien identisch sein       EX Tabelle309
$vHeader = "Name"               # Vergleichs-Header                                         EX Name

$scriptspeed = "2"              # Dauer der Textausgabe in Sekunden                         EX 3


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringvergleichb = [System.String]::Concat("`n   Beginne Vergleich: ", $xlm, " - ", $xls, "`n`n")
$stringmodulexcelinstall = [System.String]::Concat("`n `n   PowerShell-Modul: ", $excelmodul, " nicht installiert!", "`n", "   Installiere Modul...", "`n")

$dateityp = "xlsx"
$xlm = ("$xlsxpath\$xlsxMaster.$dateityp")
$xls = ("$xlsxpath\$xlsxdiff.$dateityp")
$xlneu = [System.String]::Concat("$xlsxpath\VERGLEICH.$dateityp")

$excelmodul = "ImportExcel"         # Zu importierendes PowerShell Modul

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}
#--- Module Check -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "`n   Checke Excel-Modul...`n"
waittimer

# Check ob Modul installiert ist
if (-not (Get-Module -ListAvailable -Name $excelmodul)) 
{
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringmodulexcelinstall -ForegroundColor Cyan
    waittimer

    Install-Module -Name $excelmodul -Confirm:$false        # PowerShell-Modul installieren

    # Check ob Installation erfolgreich war
    if (-not (Get-Module -ListAvailable -Name $excelmodul)) 
    {
        Clear-Host
        Write-Host $stringhost -ForegroundColor Magenta
        Write-Host "`n `n   Modulinstallation NICHT erfolgreich! Breche Vorgang ab. `n   Beende Script in 10 Sekunden... `n `n" -ForegroundColor DarkRed
        Start-Sleep -Seconds 10
    
        Exit    # Script beenden
    }

}

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "`n   Excel-Modul installiert! Lade Modul...`n"
waittimer

Import-Module -Name $excelmodul                             # Modul in Session importieren

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringvergleichb
waittimer

Compare-WorkSheet $xlm $xls -WorkSheetName $sheetname -Key $vHeader | Export-Excel -Path $xlneu -AutoSize

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "`n   Vergleich abgeschlossen`n`n"
waittimer


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID       # Shell schliessen

