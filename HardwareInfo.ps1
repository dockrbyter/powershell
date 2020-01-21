<#
HardwareInfos.ps1
Listet Mainboard, CPU, GPU und RAM Informationen auf
#>

#-----------------------------------------------------------------------------------------------
$cpuinfos = Get-WmiObject -Class Win32_Processor
$boarinfos = Get-WmiObject -Class Win32_BaseBoard -ComputerName $computer
$raminfo = Get-WmiObject -Class Win32_PhysicalMemory -ComputerName $computer
$gpuinfos = Get-Wmiobject Win32_VideoController | Select-Object -Property -Property Name

$computer = $env:computername

#-----------------------------------------------------------------------------------------------

Clear-Host

Write-Host "   GPU: $gpuinfos"








pause