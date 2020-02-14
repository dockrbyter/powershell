<#
chdmaker.ps1
.DESCRIPTION

    Erstellt Virtuelle Festplatten im VHDX-Format
    
https://github.com/thelamescriptkiddiemax/powershell/Hyper-V
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$vhdname = "vhd2"       # VHD-Name
$vhdsize = "30"         # VHD Groesse in GB
$vhdpath = "$env:PUBLIC\Documents\Hyper-V\Virtual Hard Disks\"      # Speicherort VHD - Standard: $env:PUBLIC\Documents\Hyper-V\Virtual Hard Disks\


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")
$stringintro = [System.String]::Concat("  VHD: ", $vhdname,  "   ", $vhdsize, "GB    wird erstellt...")
$vhdname = [System.String]::Concat($vhdname, ".vhdx")
$vhdsize = [System.String]::Concat($vhdsize, "GB")
$vhdpath = [System.String]::Concat($vhdpath, "\", $vhdname)
$vhdtyp = [System.String]::Concat("-", $vhdtyp)


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   Es ist Zeit fuer VHDs!"
Start-Sleep -Seconds 2

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   (F)ixe-, oder (D)ynamische-Groesse? Default - Fix"
$Readhost = Read-Host " ( F / D ) "
Switch ($ReadHost) 
 {
   F {$vhdtyp = "Fix"; Clear-Host; Write-Host $stringhost -ForegroundColor Magenta;  Write-Host $stringintro; Start-Sleep -Seconds 2;
    New-VHD -Path $vhdpath -Fixed -SizeBytes (Invoke-Expression $vhdsize)} 

   D {$vhdtyp = "Dynamisch"; Clear-Host; Write-Host $stringhost -ForegroundColor Magenta;  Write-Host $stringintro; Start-Sleep -Seconds 2;
   New-VHD -Path $vhdpath -Dynamic -SizeBytes (Invoke-Expression $vhdsize)}

   Default {$vhdtyp = "Fix"; Clear-Host; Write-Host $stringhost -ForegroundColor Magenta;  Write-Host $stringintro; Start-Sleep -Seconds 2;
   New-VHD -Path $vhdpath -Fixed -SizeBytes (Invoke-Expression $vhdsize)} 
 } 


