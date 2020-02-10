<#
nasmount.ps1

    Mountet Netzlaufwerke,
    sorgt geplante Task dafür, dass sinnloser Windowsfehler
    nicht ausgeloest wird.

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$smbadresse = "10.13.13.11"

$smbfreigabe1 = "Max"
        $smblocal1 = "H"
$smbfreigabe2 = "Media"
        $smblocal2 = "M"
$smbfreigabe3 = "Backup"
        $smblocal3 = "Z"


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " @ Windows 10: ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format “dd/MM/yyyy HH:mm:ss), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n")

$stringinterface = [System.String]::Concat("   Credentials fuer ", $smbadresse, " benoetigt!", "`n", "`n")
$stringmap = [System.String]::Concat("   Folgende Netzwerkspeicher werden gemapt:", "`n",
"   [ ", $smbfreigabe1, " ]  ", $smblocal1, ":", "`n",
"   [ ", $smbfreigabe2, " ]  ", $smblocal2, ":", "`n",
"   [ ", $smbfreigabe3, " ]  ", $smblocal3, ":", "`n")

$smbshare1 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe1)
$smbshare2 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe2)
$smbshare3 = [System.String]::Concat("\\", $smbadresse, "\", $smbfreigabe3)


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringinterface

$smbcred = Get-Credential

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringmap
Start-Sleep -Seconds 3


New-PSDrive -Name $smblocal1 -PSProvider FileSystem -Root "$smbshare1" -Persist -Credential $smbcred -Scope Global
New-PSDrive -Name $smblocal2 -PSProvider FileSystem -Root "$smbshare2" -Persist -Credential $smbcred -Scope Global
New-PSDrive -Name $smblocal3 -PSProvider FileSystem -Root "$smbshare3" -Persist -Credential $smbcred -Scope Global

Start-Sleep -Seconds 2

