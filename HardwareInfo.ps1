<#
HardwareInfos.ps1
Listet Mainboard, CPU, GPU und RAM Informationen auf
#>


$computer = $env:computername

# Wenn noetig Admin-Rechte anfordern

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

# Hardware Check

Get-WmiObject -Class Win32_BaseBoard -ComputerName $computer

Get-WmiObject -Class Win32_Processor

Get-Wmiobject Win32_VideoController

Get-WmiObject -Class Win32_PhysicalMemory -ComputerName $computer

pause