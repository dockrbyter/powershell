<#
ExcelSieb.ps1
.DESCRIPTION

    Vergleicht XLSX-Dateien und listet Unterschiede auf.
    Script muss sich im selben Verzeichnis wie XLSX-Dateien befinden!
    Header und Worksheetname muessen bei beiden Dateien identisch sein!
    Wenn die Variable $ihead1 leer ist, wird der Vergleich mit allen Header
    durchgefuehrt. Um Header bei dem Vergleich zu ignorieren, die Variablen
    $ihead1 bis $ihead5 mit Headernamen befuellen. Wenn mehr Header
    ignoeriert werden muessen, einfach unter $ihead5 erweitern ($ihead6, $ihead7, ...).
    Die neuen Header muessen in der Variable $exheads ergaenzt werden (Zeile 47).

    Das Script benoetigt das "ImportExcel-Modul". Sollte sich das Modul nicht
    auf dem System befinden, wird das Script die Installation des Moduls versuchen.
    Wenn die Installation scheitert, das Script mit erhoehten Rechten erneut ausfuehren.

    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$refxlxs = ""                               # Quelldatei (ohne Dateiendung)                         EX  Master
$difxlsx = ""                               # Differenzdatei (ohne Dateiendung)                     EX  inventar

$sheetname = ""                             # Worksheetname (muss in den Dateien identisch sein)    EX  Tabelle1

#                                             Zu ignorierende Header                                EX  $ihead1 = "Nummer", $ihead2 = "Standort"
$ihead1 = ""
$ihead2 = ""
$ihead3 = ""
$ihead4 = ""
$ihead5 = ""

$scriptspeed = "2"                          # Darstellungsdauer der Textausgaben in Sekunden        EX  2

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringmodulexcelinstall = [System.String]::Concat("`n `n   PowerShell-Modul: ", $excelmodul, " nicht installiert!", "`n", "   Installiere Modul...", "`n")

$pref = ("$PSScriptroot\$refxlxs.xlsx")                         # Pfaderstellung Refferenzdatei
$pdif = ("$PSScriptroot\$difxlsx.xlsx")                         # Pfaderstellung Differenzdatei

$exheads = ($ihead1, $ihead2, $ihead3, $ihead4, $ihead5)        # Bei Abgleich zu ignorierende Spalten

$excelmodul = "ImportExcel"                                     # Zu importierendes PowerShell Modul

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

function scripthead {

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "###########################`n######## ExcelSieb ########`n###########################"

}

#--- Begruessung --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead
waittimer

#--- Module Check -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Checke Excel-Modul..."
waittimer

# Check ob Modul installiert ist
if (-not (Get-Module -ListAvailable -Name $excelmodul)) 
{
    scripthead
    Write-Host $stringmodulexcelinstall -ForegroundColor Cyan
    waittimer

    Install-Module -Name $excelmodul -Confirm:$false        # PowerShell-Modul installieren

    # Check ob Installation erfolgreich war
    if (-not (Get-Module -ListAvailable -Name $excelmodul)) 
    {
        scripthead
        Write-Host "`n `n   Modulinstallation NICHT erfolgreich! Breche Vorgang ab. `n   Beende Script in 10 Sekunden... `n `n" -ForegroundColor DarkRed
        Start-Sleep -Seconds 10
    
        stop-process -Id $PID                               # Shell schliessen
    }

}

Import-Module -Name $excelmodul                             # Modul in Session importieren

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead
Write-Host "    Excel-Modul bereit!"
waittimer

scripthead
Write-Host "    Beginne Verarbeitung :D "
waittimer

#--- Neudaten mit Bestandsdaten abgleichen ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if (!$ihead1) {
    
    scripthead
    Write-Host "   Vergleiche inklusive ALLER Header"
    waittimer

    Compare-WorkSheet -Referencefile $pref -Differencefile $pdif -WorkSheetName $sheetname | Export-Excel -Path $pref -WorksheetName $sheetname -Append -AutoSize

}else {
    
    scripthead
    Write-Host "   Vergleiche mit Header-Auschluss"
    waittimer 

    Compare-WorkSheet -Referencefile $pref -Differencefile $pdif -ExcludeProperty $exheads -WorkSheetName $sheetname | Export-Excel -Path $pref -WorksheetName $sheetname -Append -AutoSize

}

scripthead
Write-Host "    Verarbeitung abgeschlossen! " -ForegroundColor Yellow
waittimer

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID       # Shell schliessen
