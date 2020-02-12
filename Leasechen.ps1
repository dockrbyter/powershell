<#
Leasechen.ps1
.DESCRIPTION

    DHCP-Lease Bearbeitungs-Tool fuer Windows Server 2012-R2 und neuer

https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$leaseBEREICH = ""                                          # Variable leaseBEREICH      -> Der IP Bereich aus dem Leases geaendert werden sollen
$leaseTEILBEREICH = "$leaseBEREICH.Length-3"                # Variable leaseTEILBEREICH  -> Die ersten 3x3 Stellen IP Bereich aus dem Leases geaendert werden sollen
$leaseZIEL = ""                                             # Variable leaseZIEL         -> Die letzten 3 Stellen der IP, die bearbeiten werden soll
$leaseBEARBEITUNG = "$leaseTEILBEREICH.$leaseZIEL"          # Variable leaseBEARBEITUNG  -> Setzt sich aus leaseTEILBEREICH und leaseZIE zusammen, ergibt zu bearbeitende IP
$leaseNEU = ""                                              # Variable leaseNEU          -> IP nach der Bearbeitung

#--- Vorbereitung-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host

    Write-Host "   "
    Write-Host "        Leasechen"
    Write-Host "   "
    Write-Host "   DHCP-Lease Bearbeitungs-Tool fuer Windows Server 2012-R2 und neuer"
    Write-Host "   "
    Write-Host "   Vorbereitung"
    Write-Host "   "
    
    Write-Host "   Bitte Adressbereich vorhandener Leases eingeben,"
    Write-Host "   die bearbeitet werden sollen."
    $leaseBEREICH = Read-Host "Beispiel: 192.168.0.0"                                                   # Eingabe Adressbereich
                
    Clear-Host

    Write-Host "   "
    Write-Host "   Vorhandene Leases aus Wahlbereich:"
    Write-Host "   "

    Get-DhcpServerv4Lease -ScopeId $leaseBEREICH                                                        # Ausgabe Vorhandener Leases im gewaehlten Adressbereich

    Write-Host "   "
    Write-Host "   "
    Write-Host "   Bereit fuer Aenderungen"
    Write-Host "   "

#--- Verarbeitung--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Do {
    Clear-Host
    
    Write-Host "   Welche IP soll geaendert werden?"
    Write-Host "   Bitte die letzten 3 Stellen eingeben"

    $leaseZIEL = Read-Host "Beispiel: 051"                                                                     # Eingabe zu bearbeitende IP
    
    Write-Host "   "
    Write-Host "   Wie soll die neue IP lauten?"
    Write-Host "   Bitte die vollstaendige IP eingeben"
   
    $leaseNEU = Read-Host "Beispiel: 100.010.010.005"                                                          # Eingabe neue IP

    Get-DhcpServerv4Lease -IPAddress $leaseBEARBEITUNG | Add-DhcpServerv4Reservation -IPAddress $leaseNEU      # Neues Lease setzen

    Clear-Host
    Write-Host "   "
    Write-Host "   Neue IP: $leaseNEU"
    Write-Host "   "
    Write-Host Weitere Leases bearbeiten? `(y/n`)                                                              # Anfrage y/n fuer weitere Bearbeitung


    Clear-Variable -name leaseZIEL                                                                             # Variable leaseZIEL leeren
    Clear-Variable -name leaseNEU                                                                              # Variable leaseNEU leeren

}   
Until ($ANSWER -eq 'n')                                                                                        # Schleife bei n schliessen   

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

exit
