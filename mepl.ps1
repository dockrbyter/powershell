<#
mepl.ps1
.DESCRIPTION

    MaxEasyProcessLogger
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$logpath = "C:\testordner"
$logdatei = "prozesslogs.csv"


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$logding = "$logpath\$logdatei"

If(!(test-path $logpath))
{
      New-Item -ItemType Directory -Force -Path $path
      New-Item -Path $logpath -Name $logdatei -ItemType "file" -Value "Prozesse"
}

Get-Process | Out-File $logding -Append -Encoding Unicode

