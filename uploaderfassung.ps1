<#
Uploaderfassung.ps1
.DESCRIPTION

    Erfasst Datein aus Quellordner,
    fuegt erfasste Daten Controll-XLSX zu
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$quellverzeichnis = "D:\Upload"         # Verzeichnis der einzulesenden Dateien
$zielverzeichnis = $quellverzeichnis    # Verzeichnis der XLSX

$uploaddatei = "upload.xlsx"            # Dateiname XLSX
$sheetname = "Upload Control"           # Sheet-Name

$dateityp = "jpg"                       # Zu erfassebder Dateityp


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

$stringerfassung = [System.String]::Concat("   Erfassung erledigt!   ", "`n", "         ", $zielpfadCSV1, "`n", "         ", $zielpfadCSV2, "`n", "`n", "   Beginne mit Nachbearbeitung...", "`n")
$stringmodulexcelinstall = [System.String]::Concat("`n `n   PowerShell-Modul: ", $excelmodul, " nicht installiert!", "`n", "   Installiere Modul...", "`n")
$stringertmpcsvrem = [System.String]::Concat("   Temp-CSV's - ", $tempCSVdatei1, " - ", $tempCSVdatei2, " - entfernt!   ", "`n", "`n", "       Temp-XLSX - ", $tempXLSXdatei, " - erstellt!", "`n")
$stringxls = [System.String]::Concat("`n  ", $tempXLSXdatei," entfernt!", "`n")
$stringdummy = [System.String]::Concat("`n  ", $dummypfad, " erstell!", "`n")

$excelstringdummy = [System.String]::Concat($quellverzeichnis, "\dummy.", $dateityp)

$chead1 = "Dateiname"               # Control-Sheet Head 1
$chead2 = "TietelDE"                # Control-Sheet Head 2
$chead3 = "TietelENG"               # Control-Sheet Head 3
$chead4 = "TietelESP"               # Control-Sheet Head 4
$chead5 = "SHEETZUGRIFF"            # Control-Sheet Head 5
$chead6 = "Check SpreadshirtDE"     # Control-Sheet Head 6
$chead7 = "Check SpreadshirtCOM"    # Control-Sheet Head 7
$chead8 = "Check Redbubble"         # Control-Sheet Head 8
$chead9 = "Check Teezily"           # Control-Sheet Head 9
$chead10 = "Check Shirtee"          # Control-Sheet Head 10

$cdummy1 = $excelstringdummy        # Control-Sheet Dummy-Eintrag 1
$cdummy2 = "dummy"                  # Control-Sheet Dummy-Eintrag 2
$cdummy3 = "Dummy"                  # Control-Sheet Dummy-Eintrag 3
$cdummy4 = "El Dummy"               # Control-Sheet Dummy-Eintrag 4
$cdummy5 = "DummySheet"             # Control-Sheet Dummy-Eintrag 5
$cdummy6 = "Erledigt"               # Control-Sheet Dummy-Eintrag 6
$cdummy7 = "Erledigt"               # Control-Sheet Dummy-Eintrag 7
$cdummy8 = "Erledigt"               # Control-Sheet Dummy-Eintrag 8
$cdummy9 = "Erledigty"              # Control-Sheet Dummy-Eintrag 9
$cdummy10 = "Erledigt"              # Control-Sheet Dummy-Eintrag 10

$tempCSVdatei1 = "temp1.csv"        # Temp CSV 1
$tempCSVdatei2 = "temp2.csv"        # Temp CSV 2
$tempXLSXdatei = "temp1.xlsx"       # Temp XLSX

$dummyfile = "dummy.$dateityp"      # Dummy-File

# Pfadzuweiseungen
$quelle = "$quellverzeichnis\*.$dateityp"
$zielpfad = "$zielverzeichnis\$uploaddatei"
$zielpfadCSV1 = "$zielverzeichnis\$tempCSVdatei1" 
$zielpfadCSV2 = "$zielverzeichnis\$tempCSVdatei2"
$zielpfadXLSXtemp1 = "$zielverzeichnis\$tempXLSXdatei"
$dummypfad = "$quellverzeichnis\$dummyfile"

$tempsheet1 = "Full"                # Temp-Sheet-Name 1
$tempsheet2 = "Base"                # Temp-Sheet-Name 2

$exheads = ($chead3, $chead4, $chead5, $chead6, $chead7, $chead8, $chead9, $chead10)    # Bei Abgleich zu ignorierende Spalten

$excelmodul = "ImportExcel"         # Zu importierendes PowerShell Modul

#--- Module Check -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Checke Excel-Modul..."
Start-Sleep -Seconds 2

# Check ob Modul installiert ist
if (-not (Get-Module -ListAvailable -Name $excelmodul)) 
{
    #Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringmodulexcelinstall -ForegroundColor Cyan
    Start-Sleep -Seconds 3

    Install-Module -Name $excelmodul -Confirm:$false        # PowerShell-Modul installieren

    # Check ob Installation erfolgreich war
    if (-not (Get-Module -ListAvailable -Name $excelmodul)) 
    {
        #Clear-Host
        Write-Host $stringhost -ForegroundColor Magenta
        Write-Host "`n `n   Modulinstallation NICHT erfolgreich! Breche Vorgang ab. `n   Beende Script in 10 Sekunden... `n `n" -ForegroundColor DarkRed
        Start-Sleep -Seconds 10
    
        Exit    # Script beenden
    }

}

Import-Module -Name $excelmodul                             # Modul in Session importieren


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Dateipruefung ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Test Dummy-File
If(!(test-path $dummypfad))
{

    New-Item $dummypfad

    #Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringdummy
    Start-Sleep -Seconds 1.5

}



#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Suche nach alten Temp-Daten..."
Start-Sleep -Seconds 1.5

# Test Temp-CSV's
If(test-path $zielverzeichnis\*.csv)
{

    Remove-Item $zielverzeichnis\*.csv

    #Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Temp-CSV's entfernt!"
    Start-Sleep -Seconds 1.5

}

# Test Temp-XLSX
If(test-path $zielpfadXLSXtemp1)
{

    Remove-Item $zielpfadXLSXtemp1 

    #Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Temp-CSV's entfernt!"
    Start-Sleep -Seconds 1.5

}


#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Pruefe Control-XLSX..."
Start-Sleep -Seconds 1.5

If(!(test-path $zielpfad))
{
    #Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Datei NICHT vorhanden. Erstelle neu!"
    Start-Sleep -Seconds 2
    
    $excel = New-Object -ComObject "Excel.Application"     # Bindet Excel ein
    $excel.Visible=$False                                  # Verhindert das Laden des Grafikmodus
    $excel.DisplayAlerts = $false                          # Verhindert Warnungen und Meldungen
    $workbook = $excel.Workbooks.Add()                     # Macht Workbook verfuegbar
    $worksheet = $workbook.Worksheets.Item(1)              # Legt Sheet fest
    $worksheet.Name = $sheetname                           # Namensvariable Sheet 1

    # Header Festlegen
    $worksheet.Cells.Item(1,1) = $chead1
    $worksheet.Cells.Item(1,2) = $chead2
    $worksheet.Cells.Item(1,3) = $chead3
    $worksheet.Cells.Item(1,4) = $chead4
    $worksheet.Cells.Item(1,5) = $chead5
    $worksheet.Cells.Item(1,6) = $chead6
    $worksheet.Cells.Item(1,7) = $chead7
    $worksheet.Cells.Item(1,8) = $chead8
    $worksheet.Cells.Item(1,9) = $chead9
    $worksheet.Cells.Item(1,10) = $chead10

    # Dummy-Eintraege
    $worksheet.Cells.Item(2,1) = $cdummy1
    $worksheet.Cells.Item(2,2) = $cdummy2
    $worksheet.Cells.Item(2,3) = $cdummy3
    $worksheet.Cells.Item(2,4) = $cdummy4
    $worksheet.Cells.Item(2,5) = $cdummy5
    $worksheet.Cells.Item(2,6) = $cdummy6
    $worksheet.Cells.Item(2,7) = $cdummy7
    $worksheet.Cells.Item(2,8) = $cdummy8
    $worksheet.Cells.Item(2,9) = $cdummy9
    $worksheet.Cells.Item(2,10) = $cdummy10   

    $workbook.SaveAs($zielpfad)                             # Workbook unter Zielpfad speichern
    $workbook.Close()                                       # Workbook schliessen
    $excel.Quit()                                           # Excel schliessen

}


#--- Datenerfassung -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Control-XLSX Ok. Beginne Datenerfassung..."
Start-Sleep -Seconds 1.5

Get-ChildItem $quelle | Select-Object FullName | Export-Csv $zielpfadCSV1 -NoTypeInformation -Encoding UTF8 -force     # Volle Pfadangabe erfassen
Get-ChildItem $quelle | Select-Object BaseName | Export-Csv $zielpfadCSV2 -NoTypeInformation -Encoding UTF8 -force     # Nur Dateiname ohne Endung erfassen

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringerfassung
Start-Sleep -Seconds 1.5


#--- Nachbearbeitung ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Temp-CSV's zu Temp-XLSX zusammenfassen -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Import-Csv -Path $zielpfadCSV1 | Export-Excel -Path $zielpfadXLSXtemp1 -WorkSheetname $tempsheet1       # Temp-CSV1 zu Temp-XLSX
Import-Csv -Path $zielpfadCSV2 | Export-Excel -Path $zielpfadXLSXtemp1 -WorkSheetname $tempsheet2       # Temp-CSV2 zu Temp-XLSX

Remove-Item $zielverzeichnis\*.csv                                                                      # Temp-CSV's loeschen

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringertmpcsvrem
Start-Sleep -Seconds 1.5


#--- Daten Control-XLSX hinzufuegen -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$excel = New-Object -ComObject "Excel.Application"          # Bindet Excel ein
$excel.Visible=$False                                       # Verhindert das Laden des Grafikmodus
$excel.DisplayAlerts = $false                               # Verhindert Warnungen und Meldungen

$workbook = $excel.Workbooks.open($zielpfadXLSXtemp1)       # Temp-XLSX oeffnen
$worksheet = $Workbook.WorkSheets.item($tempsheet2)         # Sheet 2 auswaehlen
$worksheet.activate()                                       # Sheet 2 aktivieren

$range = $WorkSheet.Range("A1").EntireColumn                # Range auswaehlen (A)
$range.Copy() | out-null                                    # Range copieren

$worksheet = $Workbook.Worksheets.item($tempsheet1)         # Sheet 1 auswahlen
$range = $Worksheet.Range("B1")                             # Range auswaehlen (B)
$worksheet.Paste($range)                                    # Content einfuegen
$worksheet.Cells.Item(1,1) = $chead1                        # Header 1 anpassen
$worksheet.Cells.Item(1,2) = $chead2                        # Header 2 anpassen
$worksheet.Name = $sheetname                                # Worksheet 1 unbenennen

$workbook.Save()                                            # Workbook speichern
$excel.Quit()                                               # Excel schliessen

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Vorbereitungen erledigt. Beginne Datenvergleich..."
Start-Sleep -Seconds 1.5


#--- Neudaten mit Bestandsdaten abgleichen ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Compare-WorkSheet -Referencefile $zielpfad -Differencefile $zielpfadXLSXtemp1 -ExcludeProperty $exheads -WorkSheetName $sheetname | Export-Excel -Path $zielpfad -WorksheetName $sheetname -Append -AutoSize

Remove-Item $zielpfadXLSXtemp1      # Temp-XLSX loeschen

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringxls
Start-Sleep -Seconds 1.5

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "`n     VERARBEITUNG ABGESCHLOSSEN! `n `n" -ForegroundColor Yellow
Start-Sleep -Seconds 3

