<#
sheetcompare.ps1
.DESCRIPTION

    Vergleicht 2 XLSX-Dateien
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$dateityp = "xlsx"
$xlsxpath = "G:\schulen_raw"
$xlsxMaster = "2020_01_Liste-fuer-GIS-Karte_V06"
$xlsxSlave = "schulnamen2.0"

$sheetname = "Tabelle1"

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringvergleichb = [System.String]::Concat("`n   Beginne Vergleich: ", $xlm, " - ", $xls, "`n`n")

$xlm = ("$xlsxpath\$xlsxMaster.$dateityp")
$xls = ("$xlsxpath\$xlsxSlave.$dateityp")
$xlneu = [System.String]::Concat("$xlsxpath\VERGLEICH.$dateityp")

Import-Module -Name ImportExcel

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringvergleichb
Start-Sleep -Seconds 3

Compare-WorkSheet -Referencefile $xlm -Differencefile $xls -WorkSheetName $sheetname | Export-Excel -Path $xlneu -WorksheetName $sheetname -AutoSize

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "`n   Vergleich abgeschlossen`n`n"
Start-Sleep -Seconds 3

