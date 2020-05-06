<#
VORLAGE.ps1
.DESCRIPTION

    Script-Vorlage
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$downloadlink = "http://media.steampowered.com/installer/steamcmd.zip"

$zielpfad = "C:\Users\max\Desktop\test"


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

$zipname = "temp"
$zipnameF = [System.String]::Concat($zipname, ".zip")
$downloadzip = ("$zielordner\$zipnameF")
$ziel = ("$zielpfad\$zielordner")
$jobnamezip = "zipextract"

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Beginne Download..."
Start-Sleep -Seconds 2

Invoke-WebRequest -Uri $downloadlink -OutFile $downloadzip      

#Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   ...Download abgeschlossen. Entpacke..."
Start-Sleep -Seconds 2

Start-Job -Name "zipextract" -scriptblock
    { 
        Param($downloadzip, $ziel)
        foreach ($d in $downloadzip){
            Expand-Archive -Path $d.FullName -DestinationPath $ziel\$($d.BaseName) -Verbose
        }
    }
Wait-Job -Name "zipextract"






#Remove-Item -Path $steamCMDdir\*.zip




#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID       # Shell schliessen

