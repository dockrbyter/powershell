<#
dhcp-concierge.ps1
.DESCRIPTION

    Script-Vorlage
    
https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$dchpServerIp = ""          # IP-Adresse des DHCP-Servers

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


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function waittimer {
    Start-Sleep -Seconds $scriptspeed
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host " "
waittimer

pause


foreach ($dhcpclient in $dhcpclients) {

    foreach($raeum in $raeume) {
        $matchctr = ($dhcpclient.HostName -like $raeum | Get-DhcpServerv4Lease -IPAddress $dhcpclient.IP-Adresse)
    
        if ($matchctr -eq "True") {
            #Add-DhcpServerv4Reservation -IPAddress $leaseNEU
        }
    
    
    }



}





if($dhcpclient.HostName -like $raeume){

}











#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




stop-process -Id $PID       # Shell schliessen
