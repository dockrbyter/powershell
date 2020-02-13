<#
chdmaker.ps1
.DESCRIPTION

    Erstellt Virtuelle Festplatten im VHDX-Format
    
https://github.com/thelamescriptkiddiemax/powershell/Hyper-V
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$vhdname = "vhd1"
$vhdsize = "30"
$vhdpath = 


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")

$vhdname = [System.String]::Concat($vhdname, ".vhdx")
$vhdsize = [System.String]::Concat($vhdsize, "GB")
$vhdpath = [System.String]::Concat($vhdpath, "\", $vhdname)

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
Start-Sleep -Seconds 1

pause

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



