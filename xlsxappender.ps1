<#
xlsxappender.ps1
.DESCRIPTION

    Unterstuetzungsscript fuer den ExcelSieb

    Importiert alle XLSX-Dateien aus Quellordner und fasst sie im Zielordner zu einer XLSX zusammen.

    EX  Der Speicherpfad des Scripts lautet C:\excel\ESiebKonverter.ps1, 
        dann muss der Unterordner sich in C:\excel\* befinden.
        Selbiges gillt fuer den Zielordner
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$sheetname = ""                             # Worksheetname der XLSX-Datei                                                      EX  Tabelle1

$quellordner = ""                           # Ordner in dem sich die CSV-Dateien befinden                                       EX  CSVraw
$zielordner = ""                            # Ordner in dem XLSX-Dateien gespeichert werden                                     EX  XLSX

$scriptspeed = "2"                          # Darstellungsdauer der Textausgaben in Sekunden            EX  2

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

$fquell = ("$PSScriptroot\$quellordner")
$fziel = ("$PSScriptroot\$zielordner")



#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " xlsxappender"
waittimer

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " xlsxappender`n   Beginne Verarbeitung..."
waittimer

Get-ChildItem $fquell\*.xlsx | Foreach-Object {    
            
    $zielname = [System.String]::Concat($xlsxname, ".xlsx")

    Import-Excel -Path $_ | Export-Excel -Path $fziel\$zielname -WorkSheetname $sheetname -Append -AutoSize

}

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " xlsxappender`n   ...erledigt!"
waittimer

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




stop-process -Id $PID       # Shell schliessen

