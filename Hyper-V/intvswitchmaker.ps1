<#
intvswitchmaker.ps1
.DESCRIPTION

    Erstellt virtuelle interne / private Switche fuer Hyper-V
    
https://github.com/thelamescriptkiddiemax/powershell/Hyper-V
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$switchName = "IntPowerVswitch"    # Name
$switchnotes = "Hyper-V `n Virtueller interner Switch `n Intergalaktische protonengetriebene elektrische Wackelarmwerbedroiden!"

$switchtyp = "Internal"     # Switch-Typ: Internal / Private

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("`n", "[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ")
$stringswitch1 = [System.String]::Concat("   Erstellen wir einen ", $switchtyp, " V-Switch, nennen wir ihn doch: ", $switchName, "`n", "`n")
$stringswitch2 = [System.String]::Concat("   Ok, dein - ", $switchName, " - ist fertig!", "`n", "   Nochmal: Das ist ein ", $switchtyp, " V-Switch!", "`n", "`n")

$adapter = Get-NetAdapter
$switchnic = $selection


#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringswitch1
Start-Sleep -Seconds 3
Clear-Host

Write-Host $stringhost -ForegroundColor Magenta

$menu = @{}

for ($i=1 ; $i -le $adapter.count ; $i++) { 
    
    Write-Host "$i. $($adapter[$i-1].Name))"
    $menu.Add($i,($adapter[$i-1].Name)) 
 
 }

[int]$ans = Read-Host "Welche NIC soll der V-Switch nutzen?"
$selection = $menu.Item($ans)

New-VMSwitch -Name $switchName -NetAdapterName $switchnic -AllowManagementOS $true -Notes $switchnotes -SwitchType $switchtyp -Confirm

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host $stringswitch2
Start-Sleep -Seconds 3
Clear-Host

