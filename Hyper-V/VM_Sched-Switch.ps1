<#
VM_Sched-Switch.ps1
.DESCRIPTION

    Startet, bzw. stoppt VMs, abhaengig von Status

    Script fuer Scheduled Tasks

    - Geplante Task erstellen (2x - VM-Startzeit, - VM-Stopzeit)
        - Benutzer oder Gruppe auswaehlen BSP LocalComputer\Users
        - Neuer Trigger: Uhrzeit
        - Aktion: Programm starten
            * Powershell.exe
            * Argumente: -windowsstyle hidden -command .\VM_Sched-Switch.ps1
            * Starten in: Speicherort des Scripts
    
https://github.com/thelamescriptkiddiemax/powershell/Hyper-V
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$vmname = "Kratos"                                  # Name der zuverwaltenden VM


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$vmstatus = (Get-VM -Name $vmname).State            # VM Status abrufen


if ($vmstatus -eq 'Running')                        # If VM-Status "Running"...
    {
        Stop-VM -Name $vmname                       # ...stoppe VM...
    }
else                                                # ...else VM-Status NICHT "Running"....
    {
    Start-VM -Name $vmname                          # ...starte VM
    }

stop-process -Id $PID                               # Script beenden

