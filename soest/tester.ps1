


$scriptdatei = $MyInvocation.MyCommand.Name                                                 # Script-Variable zusammenbauen
$scriptquelle = [System.String]::Concat($PSScriptRoot, "\", $MyInvocation.MyCommand.Name)   # Script-Variable zusammenbauen

$scripttarget = "$scriptfilepath\$scriptdatei"     # Script-Variable zusammenbauen
$scripttarget = [System.String]::Concat($scriptfilepatht, "\", $scriptdatei)   # Script-Variable zusammenbauen




$scriptjobname = ($scriptdatei  -replace ".{4}$")

Write-Host " "
Write-Host "Ganzer Pfad"
Write-Host $scriptquelle
Write-Host " " 

Write-Host " "
Write-Host "Mit Endung"
Write-Host $scriptdatei
Write-Host " "

Write-Host " "
Write-Host "Ohne Endung"
Write-Host $scriptjobname
Write-Host " "