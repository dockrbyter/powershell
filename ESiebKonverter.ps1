<#
ESiebKonverter.ps1
.DESCRIPTION

    Unterstuetzungsscript fuer den ExcelSieb

    Speichert alle CSV-Dateien aus einem Unterordner als XLSX in Zielordner
    und benennt jeweils das erste Worksheet entsprechend der Variable
    "$sheetname".
    EX  Der Speicherpfad des Scripts lautet C:\excel\ESiebKonverter.ps1, 
        dann muss der Unterordner sich in C:\excel\* befinden.
        Selbiges gillt fuer den Zielordner

    Appendmodus, oder nicht Appendmodus:
    Wenn der Appendmodus aktiviert ist, wird nur eine Datei erstellt
    in dem der Inhallter aller CSV's zusammengefasst wird. 

https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$xlsxname = ""                              # Namenspraefix der XLSX-Dateien                                                    EX  convert
$sheetname = ""                             # Worksheetname der XLSX-Datei                                                      EX  Tabelle1

$quellordner = ""                           # Ordner in dem sich die CSV-Dateien befinden                                       EX  CSVraw
$zielordner = ""                            # Ordner in dem XLSX-Dateien gespeichert werden                                     EX  XLSX

$append = ""                                # Appendmodus - Wenn beliebiges Zeichen in Variable, Appendmodus an                 EX x
$deli = ""                                  # Delimeter (Trennzeichen) der CSV-Dateien, wenn leer geht das Script von , aus     EX ;
$scriptspeed = "2"                          # Darstellungsdauer der Textausgaben in Sekunden                                    EX  2

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

$counter = 0

$fquell = ("$PSScriptroot\$quellordner")
$fziel = ("$PSScriptroot\$zielordner")

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "`n ESiebKonverter`n   Beginne Konvertierung...`n`n"
waittimer

if (!$append) {
   
    if (!$deli) {
    
        Clear-Host
        Write-Host $stringhost -ForegroundColor Magenta
        Write-Host "`n ESiebKonverter`n   Standard-Delimeter - Appendmode AUS`n`n"
        waittimer
    
        Get-ChildItem $fquell\*.csv | Foreach-Object {
    
            $counter++
            $zielname = [System.String]::Concat($xlsxname, $counter, ".xlsx")
        
            Import-Csv $_ | Export-Excel -Path $fziel\$zielname -WorkSheetname $sheetname -AutoSize
        
        }
        
    }else {
        
        Clear-Host
        Write-Host $stringhost -ForegroundColor Magenta
        Write-Host "`n ESiebKonverter`n   Sonder-Delimeter - Appendmode AUS`n`n"
        waittimer
    
        Get-ChildItem $fquell\*.csv | Foreach-Object {
    
            $counter++
            $zielname = [System.String]::Concat($xlsxname, $counter, ".xlsx")
        
            Import-Csv $_ -Delimiter $deli | Export-Excel -Path $fziel\$zielname -WorkSheetname $sheetname -AutoSize
        
        }
        
    }
    
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "`n ESiebKonverter`n`n   ...Konvertierung abgeschlossen!`n`n"
    waittimer

}else {

    if (!$deli) {
    
        Clear-Host
        Write-Host $stringhost -ForegroundColor Magenta
        Write-Host "`n ESiebKonverter`n   Standard-Delimeter - Appendmode AN`n`n"
        waittimer
    
        Get-ChildItem $fquell\*.csv | Foreach-Object {    
            
            $zielname = [System.String]::Concat($xlsxname, ".xlsx")
        
            Import-Csv $_ | Export-Excel -Path $fziel\$zielname -WorkSheetname $sheetname -Append -AutoSize
        
        }
        
    }else {
        
        Clear-Host
        Write-Host $stringhost -ForegroundColor Magenta
        Write-Host "`n ESiebKonverter`n   Sonder-Delimeter - Appendmode AN`n`n"
        waittimer
    
        Get-ChildItem $fquell\*.csv | Foreach-Object {
                
            $zielname = [System.String]::Concat($xlsxname, ".xlsx")
        
            Import-Csv $_ -Delimiter $deli | Export-Excel -Path $fziel\$zielname -WorkSheetname $sheetname -Append -AutoSize
        
        }
            
    }
    
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "`n ESiebKonverter`n`n   ...Konvertierung abgeschlossen!`n`n"
    waittimer

}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID       # Shell schliessen
