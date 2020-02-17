<#
masssorter.ps1
.DESCRIPTION

    Tackert TXT-Files aneinander
    und entfernt Dubletten
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$txtfile1 = "tst1"  # Name der Datei1 ohne Endung
$txtfile2 = "tst1"  # Name der Datei2 ohne Endung
$txtfile3 = "tst1"  # Name der Datei3 ohne Endung
$txtfile4 = "tst1"  # Name der Datei4 ohne Endung
$txtfile5 = "tst1"  # Name der Datei5 ohne Endung
$txtfile6 = "tst1"  # Name der Datei6 ohne Endung
$txtfile7 = "tst1"  # Name der Datei7 ohne Endung
$txtfile8 = "tst1"  # Name der Datei8 ohne Endung
$txtfile9 = "tst1"  # Name der Datei9 ohne Endung
$txtfile10 = "tst1"  # Name der Datei10 ohne Endung
$txtfile11 = "tst1"  # Name der Datei11 ohne Endung

$txtrichtigschick = "sauberetxtfileFINAL"    # Name der schicken, neuen Datei ohne Endung

$dateipfad = $PSScriptRoot     # Dateipfad der TXT-Files


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringintro = [System.String]::Concat("   Hallo ", $env:UserName, "! Tackern wir ein paar TXT-Files aneinander :D :D :D")
$stringfertig = [System.String]::Concat("   ...Erledigt", "`n", "`n", "    ", $txtrichtigschick, " ist jetzt richtig schick!", "`n")
$stringworkflow = [System.String]::Concat("   Ich fasse fuer dich die Files:", "`n",
$txtfile1, " ", $txtfile2, " ",  $txtfile3, " ", $txtfile4, " ", "`n", $txtfile5, " ", $txtfile6, " ", $txtfile7, " ", $txtfile8, " ", "`n", $txtfile9, " ", $txtfile10, " ", $txtfile11, " ",
"`n", "    zu:", "`n", "      ", $txtrichtigschick , "`n", "   zusammen", "`n", "`n")

$txtf1 = [System.String]::Concat($dateipfad, "\", $txtfile1, ".txt")
$txtf2 = [System.String]::Concat($dateipfad, "\", $txtfile2, ".txt")
$txtf3 = [System.String]::Concat( $dateipfad, "\", $txtfile3, ".txt")
$txtf4 = [System.String]::Concat($dateipfad, "\", $txtfile4, ".txt")
$txtf5 = [System.String]::Concat($dateipfad, "\", $txtfile5, ".txt")
$txtf6 = [System.String]::Concat($dateipfad, "\", $txtfile6, ".txt")
$txtf7 = [System.String]::Concat($dateipfad, "\", $txtfile7, ".txt")
$txtf8 = [System.String]::Concat($dateipfad, "\", $txtfile8, ".txt")
$txtf9 = [System.String]::Concat($dateipfad, "\", $txtfile9, ".txt")
$txtf10 = [System.String]::Concat($dateipfad, "\", $txtfile10, ".txt")
$txtf11 = [System.String]::Concat($dateipfad, "\", $txtfile11, ".txt")


$txtschick = [System.String]::Concat($dateipfad, "\", $txtrichtigschick , ".txt")


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringintro
Write-Host $stringworkflow
Start-Sleep -Seconds 4

$txtcontent1 = Get-Content -Path $txtf1
$txtcontent2 = Get-Content -Path $txtf2
$txtcontent3 = Get-Content -Path $txtf3
$txtcontent4 = Get-Content -Path $txtf4
$txtcontent5 = Get-Content -Path $txtf5
$txtcontent6 = Get-Content -Path $txtf6
$txtcontent7 = Get-Content -Path $txtf7
$txtcontent8 = Get-Content -Path $txtf8
$txtcontent9 = Get-Content -Path $txtf9
$txtcontent10 = Get-Content -Path $txtf10
$txtcontent11 = Get-Content -Path $txtf11

New-Item -Path $txtschick
$txtcontent1 | Add-Content -Path $txtschick
$txtcontent2 | Add-Content -Path $txtschick
$txtcontent3 | Add-Content -Path $txtschick
$txtcontent4 | Add-Content -Path $txtschick
$txtcontent5 | Add-Content -Path $txtschick
$txtcontent6 | Add-Content -Path $txtschick
$txtcontent7 | Add-Content -Path $txtschick
$txtcontent8 | Add-Content -Path $txtschick
$txtcontent9 | Add-Content -Path $txtschick
$txtcontent10 | Add-Content -Path $txtschick
$txtcontent11 | Add-Content -Path $txtschick

Get-Content -Path $txtschick

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Ok, die Files sind zusammgenfasst, jetzt ernferne ich die Dubletten... `n `n"
Start-Sleep -Seconds 2

Get-Content $txtschick | Get-Unique | Set-Content $txtschick

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringfertig
Start-Sleep -Seconds 4

