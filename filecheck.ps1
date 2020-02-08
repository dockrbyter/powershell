

$dummycontent = [System.String]::Concat($istzeit, "                    ", $dummyfile)
$dummyfile = "$env:TEMP\dummy.txt"

Copy-Item "\\Server01\Share\Get-Widget.ps1" -Destination "\\Server12\ScriptArchive\Get-Widget.ps1.txt"

$istzeit = Get-Date
$dummycontent | Out-File -FilePath $dummyfile




if (Test-Path $dummyfile -PathType leaf)
{
    Write-Host "   Datei vorhanden!"
}





