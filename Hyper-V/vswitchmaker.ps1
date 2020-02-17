<#
vswitchmaker.ps1
.DESCRIPTION

    Hyper-V
    Erstellt virtuelle Switche
    
https://github.com/thelamescriptkiddiemax/powershell/Hyper-V
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$switchtyp = "Internal"     # Switch-Typ: Internal / Private


#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm:ss"), "`n", "[ ", $MyInvocation.MyCommand.Name, " ]", "`n","`n") 
$stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")
$stringintswitch = [System.String]::Concat("   ", $switchtyp, " vSwitch", "`n", "   (Fuer privaten vSwitch Script-Variable switchtyp editieren)")

Import-Module Hyper-V


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function intVswitchmaker {
    
    $adapter = Get-NetAdapter
    $switchnic = $selection

    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host $stringintswitch

    $menu = @{}
    for ($i=1 ; $i -le $adapter.count ; $i++) 
    { 
    
        Write-Host "$i. $($adapter[$i-1].Name))"
        $menu.Add($i,($adapter[$i-1].Name)) 
 
    }

    [int]$ans = Read-Host "Welche NIC soll der V-Switch nutzen?"
    $selection = $menu.Item($ans)

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Read-Host "   vSwitch Name?" $switchName
    Read-Host "   vSwitch Beschreibung?" $switchnotes
    Clear-Host

    New-VMSwitch -Name $switchName -NetAdapterName $switchnic -AllowManagementOS $true -Notes $switchnotes -SwitchType $switchtyp -Confirm

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   vSwitch erstellt!"
    Start-Sleep -Seconds 1.5
    Clear-Host

}
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function extVswitchmaker {
    
    $switchdesc = "External Hyper-V Switch"
    $adapter = Get-NetAdapter
    $switchnic = $selection

    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   Interner Vswitch"

    $menu = @{}
    for ($i=1 ; $i -le $adapter.count ; $i++) 
    { 
    
        Write-Host "$i. $($adapter[$i-1].Name))"
        $menu.Add($i,($adapter[$i-1].Name)) 
 
    }

    [int]$ans = Read-Host "Welche NIC soll der V-Switch nutzen?"
    $selection = $menu.Item($ans)

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Read-Host "   vSwitch Name?" $switchName
    Read-Host "   vSwitch Beschreibung?" $switchnotes
    Clear-Host

    New-VMSwitch -Name $switchName -NetAdapterName $switchnic -AllowManagementOS $true -Notes $switchnotes -NetAdapterInterfaceDescription $switchdesc -Confirm

    Clear-Host
    Write-Host $stringhost -ForegroundColor Magenta
    Write-Host "   vSwitch erstellt!"
    Start-Sleep -Seconds 1.5
    Clear-Host

}
#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   vSwitch Maker"
Start-Sleep -Seconds 2
Clear-Host

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host $stringhost -ForegroundColor Magenta
Write-Host "   (E)xterner-, oder (I)nterner-vSwitch? Default - Extern"
$Readhost = Read-Host " ( E / I ) "
Switch ($ReadHost) 
 {
   E {extVswitchmaker} 

   I {intVswitchmaker}

   Default {extVswitchmaker} 
 } 

 Clear-Host
 Write-Host $stringhost -ForegroundColor Magenta
 Write-Host "   vSwitch Maker"
 Start-Sleep -Seconds 2
 Clear-Host

