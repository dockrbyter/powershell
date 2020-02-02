<#
HardwareInfo.ps1

Listet Systeminformationen auf
Hostname, CPU, Board, RAM, GPU, NIC

#>
#--- Datenerfassung -----------------------------------------------------------------------------------------------------------------------------------------

# Raw
$winbuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId
$windom = (Get-WmiObject Win32_ComputerSystem).Domain
$cpuinfos = (Get-WmiObject Win32_Processor).Name
$boardinfohersteller = (Get-WmiObject Win32_BaseBoard).Manufacturer
$boardinfoproduct = (Get-WmiObject Win32_BaseBoard).Product
$boardinfoserial = (Get-WmiObject Win32_BaseBoard).SerialNumber
$boardfirmware = Get-WmiObject Win32_BIOS
$raminfohersteller = (Get-WmiObject Win32_PhysicalMemory).Manufacturer
$raminfogroesse = (Get-WmiObject Win32_PhysicalMemory).Capacity
$raminfoserial = (Get-WmiObject Win32_PhysicalMemory).SerialNumber
$raminfogrototal = "{0:N0}GB" -f (((Get-WmiObject -class Win32_ComputerSystem).TotalPhysicalMemory)/1GB)
$gpuinfoname = (Get-Wmiobject Win32_VideoController).Name
$gpuinforam= (Get-Wmiobject Win32_VideoController).AdapterRAM
$gpuinforeshor = (Get-Wmiobject Win32_VideoController).CurrentHorizontalResolution
$gpuinforesver = (Get-Wmiobject Win32_VideoController).CurrentVerticalResolution
$hddgb = Get-WMIObject Win32_Logicaldisk| Select DeviceID, @{Name="Total GB";Expression={$_.Size/1GB -as [int]}}, @{Name="Freie GB";Expression={[math]::Round($_.Freespace/1GB,2)}}
$hddtyp = (Get-WMIObject win32_diskdrive).model 
$netinfoadapter = Get-NetAdapter -Name "*" | Format-List -Property "Name", "InterfaceDescription", "MacAddress", "LinkSpeed"
$netinfoip = Get-NetIPAddress |Select-Object IPv4Address, InterfaceAlias


# Concat
$stringhost = [System.String]::Concat("   Host             ", $env:computername, "  ~  Windows 10 ", $winbuild, "  ~  ", $windom)
$stringcpuinfos = [System.String]::Concat("                    ", $cpuinfos)
$stringboardinfohersteller = [System.String]::Concat("   Hersteller:      ", $boardinfohersteller)
$stringboardinfoproduct = [System.String]::Concat("   Typ:             ", $boardinfoproduct)
$stringboardinfoserial = [System.String]::Concat("   Seriennummer:    ", $boardinfoserial)
$stringraminfohersteller = [System.String]::Concat("   Hersteller:      ", $raminfohersteller)
$stringraminfogroesse = [System.String]::Concat("   Groesse:         ", $raminfogroesse)
$stringraminfoserial = [System.String]::Concat("   Seriennummer:    ", $raminfoserial)
$stringraminfogrototal = [System.String]::Concat("   RAM Total:       ", $raminfogrototal)
$stringgpuinfoname = [System.String]::Concat("   Typ:             ", $gpuinfoname)
$stringgpuinforam = [System.String]::Concat("   RAM:             ", $gpuinforam)
$stringgpuinfores = [System.String]::Concat("   Aufloesung:      ", $gpuinforeshor, "  X  ", $gpuinforesver)



#--- Ausgabe ---------------------------------------------------------------------------------------------------------------------------------------

function Set-ConsoleColor ($bc, $fc) {
    $Host.UI.RawUI.BackgroundColor = $bc
    $Host.UI.RawUI.ForegroundColor = $fc
    Clear-Host
}
Set-ConsoleColor 'DarkGray' 'DarkGreen'

Clear-Host

Write-Host " "
Write-Host " "
Write-Host "          __   __   __         __   __   ___            ___  __ " 
Write-Host "    |__| |__| |__/ |  \ | | | |__| |__/ |___    | |\ | |___ |  | "  
Write-Host "    |  | |  | |  \ |__/ |_|_| |  | |  \ |___    | | \| |    |__| " 
Write-Host " "
$stringhost 
Write-Host "___________________________________________________________________________ " -ForegroundColor White
Write-Host "CPU " -ForegroundColor Blue
Write-Host " "
$stringcpuinfos
Write-Host " "
Write-Host "___________________________________________________________________________ " -ForegroundColor White
Write-Host "BOARD " -ForegroundColor Blue
Write-Host " "
$stringboardinfohersteller 
$stringboardinfoproduct
$stringboardinfoserial
Write-Host " "
$boardfirmware
Write-Host " "
Write-Host "___________________________________________________________________________ " -ForegroundColor White
Write-Host "RAM " -ForegroundColor Blue
Write-Host " "
$stringraminfohersteller
$stringraminfogroesse
$stringraminfoserial
$stringraminfogrototal
Write-Host " "
Write-Host "___________________________________________________________________________ " -ForegroundColor White
Write-Host "GPU " -ForegroundColor Blue
Write-Host " "
$stringgpuinfoname
$stringgpuinforam
$stringgpuinfores
Write-Host " "
Write-Host "___________________________________________________________________________ " -ForegroundColor White
Write-Host "HDD " -ForegroundColor Blue
Write-Host " "
Write-Host " "
$hddgb
Write-Host "Typ " -ForegroundColor Blue
Write-Host " "
$hddtyp
Write-Host " "
Write-Host "___________________________________________________________________________ " -ForegroundColor White
Write-Host "Netzwerk " -ForegroundColor Blue
Write-Host " "
$netinfoip
Write-Host " "
Write-Host "Adapter " -ForegroundColor Blue
$netinfoadapter
Write-Host " "
Write-Host "___________________________________________________________________________ " -ForegroundColor White
Write-Host " "
Write-Host " "

pause


