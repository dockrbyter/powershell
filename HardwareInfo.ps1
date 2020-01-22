<#
HardwareInfos.ps1

Listet CPU-, Board-, RAM, und GPU-Informationen auf
#>
#--- Variablen -----------------------------------------------------------------------------------------------------------------------------------------

$cpuinfos = Get-WmiObject -Class Win32_Processor | Select-Object -Property Name
$boardinfos = Get-WmiObject -Class Win32_BaseBoard | Select-Object -Property Manufacturer, Product
$raminfos = Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -Property Manufacturer, Capacity
$gpuinfos = Get-Wmiobject Win32_VideoController | Select-Object -Property Name, AdapterRAM, CurrentHorizontalResolution, CurrentVerticalResolution


#--- Verarbeitung ---------------------------------------------------------------------------------------------------------------------------------------

Clear-Host

Write-Host " "
Write-Host " "
Write-Host "   System   : " $env:computername
Write-Host " "
Write-Host "   CPU      : " $cpuinfos
Write-Host "   Board    : " $boardinfos
Write-Host "   RAM      : " $raminfos
Write-Host "   GPU      : " $gpuinfos
Write-Host " "
Write-Host " "

pause

