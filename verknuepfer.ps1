<# 
verknuepfer.ps1
.DESCRIPTION

    Script fuer .lnk Verknüpfungen

https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen -----------------------------------------------------------------------------------

$verknuepfungName = "neueVerknuepfung.lnk"                          # Name der Verknuepfung, z.B. "neueVerknuepfung.lnk"
$verknuepfungPfad = "\Program Files (x86)\Hersteller\Programm\"     # Der Pfad zu der zu verknuepfenden Datei, z.B. "\Program Files (x86)\Hersteller\Programm\"
$verknuepfungEXE = "Programm.exe"                                   # Die zu verknuepfende Date, z.B. "Programm.exe"   
$verknuepfungIcon = $verknuepfungEXE                                # Das Icon der Verknuepfung, z.B. "dateipfad\neuicon.ico"

$verknuepfungZiel = [Environment]::GetFolderPath("Desktop")         # Das Ziel der Verknuepfung, z.B. Desktop


#--- Verarbeitung ---------------------------------------------------------------------------------

$neuerLink = "$verknuepfungZiel\ + $verknuepfungName = $verknuepfungName"
$wshShellObject = New-Object -com WScript.Shell
$wshShellLink = $wshShellObject.CreateShortcut($neuerLink)
$wshShellLink.TargetPath = "$verknuepfungPfad + $verknuepfungEXE"
$wshShellLink.WindowStyle = 1
$wshShellLink.IconLocation = $verknuepfungIcon
$wshShellLink.WorkingDirectory = $verknuepfungPfad
$wshShellLink.Save()

<#

[Environment]::GetFolderPath("CommonDesktopDirectory")      -> Oeffentlicher Desktop
[Environment]::GetFolderPath("Desktop")                     -> Persoenlicher Desktop

#>

