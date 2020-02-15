<#
thrallconstructor.ps1
.DESCRIPTION

    Hyper-V
    Erstellt VMs
    
https://github.com/thelamescriptkiddiemax/powershell/Hyper-V
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$vhdpath = "$env:PUBLIC\Documents\Hyper-V\Virtual Hard Disks\"      # Speicherort VHD - Standard: $env:PUBLIC\Documents\Hyper-V\Virtual Hard Disks\



#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")

Import-Module Hyper-V

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Show-Menu
{
    param ([string]$Title = "Muss was getan werden?")
     
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
     
	Write-Host " . . .  . . . . . . . . .  $Title  . . . . . . . . .   . . . "   
    Write-Host "  1 > Externer V-Switch erstellen"
    Write-Host "  2 > Interner V-Switch erstellen"
    Write-Host "  3 > VHDs erstellen `n"
    Write-Host "  4 > VMs ERSTELLEN `n"
	Write-Host "  5 > Hyper-V-Manager oeffnen"
	Write-Host "  q > Quit"
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function vmmaker {
    
    Write-Host $stringhost -ForegroundColor Magenta
    Read-Host "  VM-Name?   BSP: Thrall03" $vmname
    Read-Host "  Wie viele Cores?   BSP: 4" $vmcores
    Read-Host "  VM RAM in GB?   BSP: 16" $vmRAMraw
    Read-Host "  VHD-Pfad?   BSP: C:\vms\vhd" $vhdpath
    Read-Host "  VHD-Name?   BSP: SVR19HD   (NUR VHDX - VHD nicht)" $vmVHDname
    Read-Host "  vSwitch-Name?   BSP: extVswitch" $switchName

    $vmRAM = [System.String]::Concat($vmRAMraw, "GB")
    $vmVHD = [System.String]::Concat($vhdpath, "\", $vhdname, ".vhdx")
    $stringVMerstellt = [System.String]::Concat("   VM ", $vmname, " erstellt!", "`n", "   Snapshots bitte selber konfigurieren!")

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Erstelle VM..."
    Start-Sleep -Seconds 1.5

    New-VM -Name $vmname -MemoryStartupBytes $vmRAM -VHDPath $vmVHD -SwitchName $switchName -Confirm
    Set-VMProcessor -VMName $vmname -Count $vmcores
    Set-VM -Name $vmname -AutomaticCheckpointsEnabled $false
    Enable-VMIntegrationService -name Gast* -VMName $vmname -Passthru
    Enable-VMIntegrationService -VMName $vmname -Name "Guest Service Interface"

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringVMerstellt
    Start-Sleep -Seconds 2
    
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function vhdmaker {

    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "Zielverzeichnis in Script-Variablen konfigurieren!" -ForegroundColor DarkRed
    Read-Host "   VHD-Name?" $vhdname
    Read-Host "   VHD-Groesse?" $vhdsize
    
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
    
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   VHD erstellt!"
    Start-Sleep -Seconds 1.5

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   ThrallConstructor"
Start-Sleep -Seconds 1.5


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do{
     Show-Menu
     $input = Read-Host "Bitte waehlen"
     switch ($input)
     {
        1 { }      # Aktion Taste 1 - 
        2 { }     # Aktion Taste 2 - 
		3 { vhdmaker }          # Aktion Taste 3 - VHDs erstellen
		4 { vmmaker }         # Aktion Taste 4 - VMs montieren
        5 { }  # Aktion Taste 5 - 
     }       
}
until ($input -eq 'q') 

