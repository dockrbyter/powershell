<#
USBstickSerial.ps1
.DESCRIPTION

    

https://github.com/thelamescriptkiddiemax/powershell
#>

Get-WmiObject Win32_USBControllerDevice |ForEach-Object{[wmi]($_.Dependent)} | Where-Object {($_.Description -like '*mass*')} | Sort-Object Description,DeviceID | Format-Table Description,DeviceID �auto

pause
