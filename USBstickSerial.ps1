<#
USBstickSerial.ps1
M@x
#>

gwmi Win32_USBControllerDevice |%{[wmi]($_.Dependent)} | Where-Object {($_.Description -like '*mass*')} | Sort Description,DeviceID | ft Description,DeviceID –auto

pause
