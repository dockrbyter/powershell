<#
thrallconstructor.ps1
.DESCRIPTION

    Hyper-V
    Erstellt VMs
    
https://github.com/thelamescriptkiddiemax/powershell/Hyper-V
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$vmpath = "$env:PUBLIC\Documents\Hyper-V\Virtual Machines"          # Speicherort VM
$vhdpath = "$env:PUBLIC\Documents\Hyper-V\Virtual Hard Disks"       # Speicherort VHD
$isopath = "$env:PUBLIC\Documents\Hyper-V\ISOs"                     # Speicherort Installations-ISOs
$switchtyp = "Internal"                                             # Switch-Typ: Internal / Private - Nur gillt nur fuer internen Vswitch


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")

$vmpath = [System.String]::Concat($vmpath, "\")
$vhdpath = [System.String]::Concat($vhdpath, "\", $vhdname, ".vhdx")
$isopath = [System.String]::Concat($isopath, "\", $isoname, ".iso")

Import-Module Hyper-V


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Show-Menu
{
    param ([string]$Title = "Muss was getan werden?")
     
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
     
	Write-Host " . . .  . . . . . . . . .  $Title  . . . . . . . . .   . . . `n" -ForegroundColor Cyan
    Write-Host "  1 > V-Switch erstellen"
    Write-Host "  2 > VHDs erstellen"
    Write-Host "  3 > VMs montieren `n"
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "  4 > VM starten und verbinden"
    Write-Host "  5 > PSSession verbinden"
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host "  6 > Hyper-V-Manager oeffnen"
    Write-Host "  7 > Hyper-V installieren `n"
    Write-Host "------------------------------------------------------------------------------------`n" -ForegroundColor Cyan
    Write-Host "  q > Quit `n `n"
    
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function vmmaker {
    
    $vmRAM = [System.String]::Concat($vmRAMraw, "GB")
    $stringVMerstellt = [System.String]::Concat("   VM ", $vmname, " erstellt!", "`n", "   Snapshots bitte manuell konfigurieren!")

    Write-Host $stringhost -ForegroundColor Magenta
    $vmname = Read-Host "  VM-Name?   BSP: Thrall03"
    $vmcores = Read-Host "  Wie viele Cores?   BSP: 4"
    $vmRAMraw = Read-Host "  VM RAM in GB?   BSP: 16"
    $vhdname = Read-Host "  VHD-Name?   BSP: SVR19HD   (NUR VHDX - VHD nicht)"
    $switchName = Read-Host "  vSwitch-Name?   BSP: extVswitch" 
    $isoname = Read-Host "  ISO-Name?   BSP: manjaro-xfce-18.1.5-191229-linux54"

    Write-Host "   ISO (E)inbinden, oder (S)kippen? Default - Einbinden `n"
    $Readhost = Read-Host " ( E / S ) "
    Switch ($ReadHost) 
    {
        E {Read-Host "  ISO-Name?" $isoname; $vmdrive = Set-VMDvdDrive -VMName $vmname -Path $isopath}

        S {$vmdrive = Set-VMDvdDrive}

        Default {Read-Host "  ISO-Name?" $isoname; $vmdrive = Set-VMDvdDrive -VMName $vmname -Path $isopath} 
    }

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Erstelle VM..."
    Start-Sleep -Seconds 1.5

    New-VM -Name $vmname -Path $vmpath -MemoryStartupBytes $vmRAM -VHDPath $vhdpath -SwitchName $switchName -Generation 2
    Set-VMProcessor -VMName $vmname -Count $vmcores
    Set-VM -Name $vmname -AutomaticCheckpointsEnabled $false
    $vmdrive
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
    $vhdname = Read-Host "   VHD-Name?"
    $vhdsize = Read-Host "   VHD-Groesse?"
    
    Write-Host "   (F)ixe-, oder (D)ynamische-Groesse? Default - Fix `n"
    $Readhost = Read-Host " ( F / D ) "
    Switch ($ReadHost) 
    {
        F {New-VHD -Path $vhdpath -Fixed -SizeBytes (Invoke-Expression $vhdsize)} 

        D {New-VHD -Path $vhdpath -Dynamic -SizeBytes (Invoke-Expression $vhdsize)}

        Default {New-VHD -Path $vhdpath -Fixed -SizeBytes (Invoke-Expression $vhdsize)} 
    }
    
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   VHD erstellt!"
    Start-Sleep -Seconds 1.5

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function menu2 {
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   (E)xterner-, oder (I)nterner-vSwitch? Default - Extern `n"
    $Readhost = Read-Host " ( E / I ) "
    Switch ($ReadHost) 
        {
            E {extVswitchmaker} 

            I {intVswitchmaker}

            Default {extVswitchmaker} 
        }
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function intVswitchmaker {
    
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Interner Vswitch"
    $switchName = Read-Host "   vSwitch Name?"
    $switchnotes = Read-Host "   vSwitch Beschreibung?"
    Clear-Host

    New-VMSwitch -Name $switchName -Notes $switchnotes -SwitchType $switchtyp

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Interner vSwitch erstellt!"
    Start-Sleep -Seconds 1.5
    Clear-Host

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function extVswitchmaker {
    
    $adapter = Get-NetAdapter

    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Externer Vswitch"

    $menu = @{}
    for ($i=1 ; $i -le $adapter.count ; $i++) 
    { 
    
        Write-Host "$i. $($adapter[$i-1].Name))"
        $menu.Add($i,($adapter[$i-1].Name)) 
 
    }

    [int]$ans = Read-Host "Welche NIC soll der V-Switch nutzen?"
    $selection = $menu.Item($ans)

    $switchnic = $selection

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    $switchName = Read-Host "   vSwitch Name?"
    $switchnotes = Read-Host "   vSwitch Beschreibung?"
    Clear-Host

    New-VMSwitch -Name $switchName -NetAdapterName $switchnic -AllowManagementOS $true -Notes $switchnotes

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Externer vSwitch erstellt!"
    Start-Sleep -Seconds 1.5
    Clear-Host

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function thrallslap {
    
    $vmsalle = Get-VM
    $vmslaufend = Get-VM | Where-Object {$_.State -eq 'Running'}

    $stringvmslocal1 = [System.String]::Concat("    Lokale VMs:", "`n", "     ", $vmsalle, "`n", "    VMs online:", "`n")
    $stringvmslocal2 = [System.String]::Concat("     ", $vmslaufend, "`n")

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringvmslocal1
    Write-Host $stringvmslocal2-ForegroundColor Yellow
    $vmstartname = Read-Host "   Wer soll dienen?"
    Write-Host $vmstartname -ForegroundColor Green
    Write-Host "   VM (S)tarten, oder (V)erbinden? Default - Starten und verbinden `n"
    $Readhost = Read-Host " ( S / V ) "
    Switch ($ReadHost) 
        {
            S { Start-VM $vmstartname } 

            V { & "C:\windows\System32\vmconnect.exe" localhost $vmstartname }

            Default { Start-VM $vmstartname
                        & "C:\windows\System32\vmconnect.exe" localhost $vmstartname} 
        }
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function pssstart {
    
    $vmsalle = Get-VM
    $vmslaufend = Get-VM | Where-Object {$_.State -eq 'Running'}

    $stringvmslocal1 = [System.String]::Concat("    Lokale VMs:", "`n", "     ", $vmsalle, "`n", "    VMs online:", "`n")
    $stringvmslocal2 = [System.String]::Concat("     ", $vmslaufend, "`n")

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringvmslocal1
    Write-Host $stringvmslocal2-ForegroundColor Yellow
    Read-Host "   Ziel-VM?" $vmpss

    Enter-PSSession -VMName $vmpss
    
}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function hypervsetup {
    
    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Installiere Hyper-V. Danach muss das System rebooten!"

    Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
    
}
#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   ThrallConstructor `n" -ForegroundColor Yellow
Write-Host "  Pfade in Scriptvariablen anpassen!" -ForegroundColor DarkRed -BackgroundColor White
Start-Sleep -Seconds 3


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
do{
     Show-Menu
     $input = Read-Host "Bitte waehlen"
     switch ($input)
     {
        1 { menu2 }             # Aktion Taste 1 - vSwitch-Menu
        2 { vhdmaker }          # Aktion Taste 2 - VHDs erstellen
		3 { vmmaker }           # Aktion Taste 3 - VMs montieren
		4 { thrallslap }        # Aktion Taste 4 - VM starten und verbinden
        5 { pssstart }          # Aktion Taste 5 - PSSession starten
        6 { virtmgmt.msc }      # Aktion Taste 6 - Hyper-V-Manager oeffnen
        7 { hypervsetup }       # Aktion Taste 7 - Hyper-V installieren
     }
}
until ($input -eq 'q') 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   ThrallConstructor `n" -ForegroundColor Yellow
Start-Sleep -Seconds 3

