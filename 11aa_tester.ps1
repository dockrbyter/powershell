<#
tester.ps1
.DESCRIPTION

    Spielwiese

https://github.com/thelamescriptkiddiemax/powershell
#>


$gamename = $gamename | Select-String -Pattern "name" | Select-Object -First 1
$gamename = $gamename.P3
$gamename = $gamename.Replace("`"","")