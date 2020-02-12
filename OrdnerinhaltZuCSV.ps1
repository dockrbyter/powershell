<#
OrdnerinhaltZuCSV.ps1
.DESCRIPTION

    Listet Dateien aus einem beliebigen Ordner auf
    und speichert diese in einer CSV-Datei ab

https://github.com/thelamescriptkiddiemax/powershell
#>



$Ordner = "C:\Neuer Ordner"     # Welchen Ordner auslesen?

$ExportPfad = "C:\Neuer Ordner" # Wo soll die Auslesedatei gespeichert werden?

$ExportDatei = "Upload"         # Wie soll die Datei heissen (nicht .csv angeben!)?

$exclude = @("*.cs*", "*.tt*", "*.xaml*", "*.csproj*", "*.sln*", "*.xml*", "*.cmd*", "*.txt*", "*.ps1*", "*.csv*, ") # Dateitypen die nicht beachtet werden sollen


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Get-ChildItem $Ordner\*.* -Exclude $exclude | Select-Object FullName | Export-Csv $ExportPfad\$ExportDatei.csv -Delimiter ","
