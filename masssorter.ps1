<#
masssorter.ps1
.DESCRIPTION

    Tackert TXT-Files aneinander
    und entfernt Dubletten
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$txtfile1 = "txt1"  # Name der Datei1 ohne Endung
$txtfile2 = "txt2"  # Name der Datei2 ohne Endung
$txtfile3 = "txt3"  # Name der Datei3 ohne Endung
$txtfile4 = "txt4"  # Name der Datei4 ohne Endung
$txtfile5 = "txt5"  # Name der Datei5 ohne Endung

$txtrichtigschick = "sauberetxtfile"    # Name der schicken, neuen Datei ohne Endung

$dateipfad = $PSScriptRoot     # Dateipfad der TXT-Files


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")
$stringintro = [System.String]::Concat("   Hallo ", $env:UserName, "! Tackern wir ein paar TXT-Files aneinander :D :D :D")
$stringfertig = [System.String]::Concat("   ...Erledigt", "`n", "`n", "    ", $txtrichtigschick, " ist jetzt richtig schick!", "`n")
$stringworkflow = [System.String]::Concat("   Ich fasse fuer dich die Files:", "`n",
                                            "      ", $txtfile1, "`n",
                                            "      ", $txtfile2, "`n",
                                            "      ", $txtfile3, "`n",
                                            "      ", $txtfile4, "`n",
                                            "      ", $txtfile5, "`n", "    zu:", "`n",
                                            "      ", $txtrichtigschick , "`n", "   zusammen", "`n", "`n")

$txtf1 = [System.String]::Concat($dateipfad, "\", $txtfile1, ".txt")
$txtf2 = [System.String]::Concat($dateipfad, "\", $txtfile2, ".txt")
$txtf3 = [System.String]::Concat( $dateipfad, "\", $txtfile3, ".txt")
$txtf4 = [System.String]::Concat($dateipfad, "\", $txtfile4, ".txt")
$txtf5 = [System.String]::Concat($dateipfad, "\", $txtfile5, ".txt")
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

New-Item -Path $txtschick
$txtcontent1 | Add-Content -Path $txtschick
$txtcontent2 | Add-Content -Path $txtschick
$txtcontent3 | Add-Content -Path $txtschick
$txtcontent4 | Add-Content -Path $txtschick
$txtcontent5 | Add-Content -Path $txtschick

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

