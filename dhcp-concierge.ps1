<#
dhcp-concierge.ps1
.DESCRIPTION

    Script-Vorlage
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$poolcsv = "C:\dhcp\pool.csv"
$clientcsv = "C:\dhcp\clients.csv"

$dchpServer = ""          # Hostname des DHCP-Servers

$domainname = ""
$domainsuffix = ""

$ippref = "10.10"
$iprangestart = "100"
$iprangeend = "200"
$sunbnetmask = "255.255.0.0"

$raeume = @(
    "NBPHY*",
    "NBMIM*",
    "NBHOLZ",
    "*E205*",
    "*E115*",
    "*F206*",
    "*F205*",
    "*F204*",
    "*F202*",
    "*F201*",
    "*F121*",
    "*F118*",
    "*F117*",
    "*F115*",
    "*F112*",
    "*F108*",
    "*F107*",
    "*F104*",
    "*F101*",
    "*F020*",
    "*F018*",
    "*F011*",
    "*F004*",
    "*F003*",
    "*E216*",
    "*E212*",
    "*E211*",
    "*E210*",
    "*E206*",
    "*E112*",
    "*E107*",
    "*E105*",
    "*E104*",
    "*E103*",
    "*E001*",
    "*D217*",
    "*D216*",
    "*D215*",
    "*D214*",
    "*D212*",
    "*D205*",
    "*D203*",
    "*D202*",
    "*D112*",
    "*D106*",
    "*D105*",
    "*D103*",
    "*D102*",
    "*D009*",
    "*D004*",
    "*D003*",
    "*D002*",
    "*D001*",
    "*C306*",
    "*C301*",
    "*C111*",
    "*C102*",
    "*C101*",
    "*BIBLIO*"

)


$scriptspeed = "2"

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

$dhcpclients = Get-DHCPServerV4Scope -ComputerName $dchpServerIp | ForEach-Object { Get-DHCPServerv4Lease -ScopeID $_.ScopeID } | Select-Object HostName, ClientID


$dhcpsrv = ("$dchpServer.$domainname.$domainsuffix")

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   dhcp-concierge"
waittimer


# DHCP Pools erstellen
Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   dhcp-concierge"
Write-Host "`n   Beginne mit Raumerstellung...`n"
waittimer

$raumcount = "0"

Import-Csv -Path $poolcsv -Header Raeume |  Foreach-Object{
    $raumcount++
    $stringcurrent = [System.String]::Concat("`n   DHCP-Pool ", $_.Raeume, "`n   Range von: ", $raumSTARTrange, " bis ", $raumENDrange, "`n")
    
    $raumSTARTrange = [System.String]::Concat("$ippref.$raumcount.$iprangestart")
    $raumENDrange = [System.String]::Concat("$ippref.$raumcount.$iprangeend")
    Add-DhcpServerv4Scope -ComputerName $dhcpsrv -Name $_.Raeume -StartRange $raumSTARTrange -EndRange $raumENDrange -SubnetMask $sunbnetmask -Description $_.Raeume

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   dhcp-concierge"
    Write-Host $stringcurrent
    waittimer
    }


# Clients den Pools zuweisen
Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   dhcp-concierge"
Write-Host "`n   Ich zeige nun unseren Gaesten ihre Zimmer...`n"
waittimer

Import-Csv -Path $dhcpclients -Header Raeume  | Add-DhcpServerv4Scope -ComputerName $dhcpsrv -State Active




#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




stop-process -Id $PID       # Shell schliessen
