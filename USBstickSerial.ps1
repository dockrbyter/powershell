<#
USBstickSerial.ps1
M@x
#>

Get-WmiObject Win32_USBControllerDevice |ForEach-Object{[wmi]($_.Dependent)} | Where-Object {($_.Description -like '*mass*')} | Sort-Object Description,DeviceID | Format-Table Description,DeviceID �auto

pause
