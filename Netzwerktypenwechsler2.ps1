<#
Netzwerktypenwechsler.ps1
.DESRIPTION
	Netzwerktypen Schnellwechsel
#>
#--- Administratorrechte anfordern -------------------------------------------------------------------------------------------------------------------------------------

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- NetzTyp ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

cls

Write-Host " "
Write-Host "        ___ ___ __       ___  __       ___      __   ___"
Write-Host "  |\ | |__   |   / |  | |__  |__) |__/  |  \ / |__) |__  |\ |"
Write-Host "  | \| |___  |  /_ |/\| |___ |  \ |  \  |   |  |    |___ | \|"
Write-Host "        ___  __        __        ___  __ "
Write-Host "  |  | |__  /    |__| /__  |    |__  |__)"
Write-Host "  |/\| |___ \__  |  |  __/ |___ |___ |  \"
Write-Host " "


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- NIC-Auswahl --------------------------------------------------------------------------------------------------------------------------------------------------------

$adapter = Get-NetConnectionProfile
$menu = @{}

for ($i=1 ; $i -le $adapter.count ; $i++) { 
    
    Write-Host "$i. $($adapter[$i-1].Name)"
    $menu.Add($i,($adapter[$i-1].Name)) 
 
 }

Write-Host " "

[int]$ans = Read-Host 'Von welchem Adapter soll der Typ auf Privat gesetzt werden?'
$selection = $menu.Item($ans)

Write-Host " "


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------



do {
  $LanTypNR = Read-Host "  Netzwerktyp?   1 = Pirvates Netzwerk   2 = Oeffentliches Netzwerk"
} until ($("1","2").Contains($LanTypNR))



$Title = "Netzwerktyp"
$Message = "Privates oder Oeffentliches Netzwerk?"
$Privat = New-Object System.Management.Automation.Host.ChoiceDescription "&Privat", `
    "Privat"
$MacOSX = New-Object System.Management.Automation.Host.ChoiceDescription "&MacOSX", `
    "MacOSX"
$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Privat, $MacOSX)
$SelectOS = $host.ui.PromptForChoice($title, $message, $options, 0) 
 
    switch($SelectOS)
    {
        0 {Write-Host "You love Windows ME!"}
        1 {Write-Host "You must be an Apple fan boy"}
    }




#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Netzwerktypen Wechsel ---------------------------------------------------------------------------------------------------------------------------------------------------

Write-Host "    Mache $selection zu $LanTyp Netzwerk!"

Set-NetConnectionProfile -Name $selection -NetworkCategory $LanTyp

Start-Sleep -s 1


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
exit
