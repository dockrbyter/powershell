<#
WSL-Setup.ps1
.DESCRIPTION
	Menue zur Installation des WLS
	ohne MS Store
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$ubuntu16 = "https://aka.ms/wsl-ubuntu-1604"	# Link Ubuntu 16.04
$ubuntu18 = "https://aka.ms/wsl-ubuntu-1804"	# Link Ubuntu 18.04
$debian = "https://aka.ms/wsl-debian-gnulinux"	# Link Debian
$kali = "https://aka.ms/wsl-kali-linux"			# Link Kali
$opensuse = "https://aka.ms/wsl-opensuse-42"	# Link OpenSUSE


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Installiert Linux Subsystem, wenn nicht vorhanden  ---------------------------------------------------------------------------------------------------------------------------------

IF ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Disabled")									# Prueft ob WLS vorhanden
	{
           
			write-host "WLS nicht bereit!"
            write-host "System wird im Anschluss neugestartet"
            write-host "Bestaetigen Sie mit Enter, um WLS bereit zu machen"

            pause

            Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -WarningAction SilentlyContinue

    } 


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Menue -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Show-Menu  						# Bildschirmausgaben (das Menue darstellen)
{
    param (
        [string]$Title = 'Distributionen'
    )
     Clear-Host
     
Write-Host "     __    __  __  __ "
Write-Host "    / / /\ \ \/ / / _\       "
Write-Host "    \ \/  \/ / /  \ \        "
Write-Host "     \  /\  / /____\ \       "
Write-Host "      \/  \/\____/\__/       "
Write-Host "     __      _ "
Write-Host "    / _\ ___| |_ _   _ _ __  "
Write-Host "    \ \ / _ \ __| | | | '_ \ "
Write-Host "    _\ \  __/ |_| |_| | |_) |"
Write-Host "    \__/\___|\__|\__,_| .__/ "
Write-Host "                      |_|    "
Write-Host "   Ohne MS-Store :D         "

Write-Host " "
Write-Host " "

	 Write-Host ">>========= $Title =========<<"
	 Write-Host " "
     Write-Host "      1 > Ubuntu 16.04"
     Write-Host "      2 > Ubuntu 18.04" 
     Write-Host "      3 > Debian GNU/Linux"
     Write-Host "      4 > Kali Linux"
	 Write-Host "      5 > OpenSUSE"
	 Write-Host " "
	 Write-Host "      Q > Beendet WLS-Setup und"
	 Write-Host "          startet Computer neu"
	 Write-Host " "
	 Write-Host " "
}
do

# Tasteneingaben

{
     Show-Menu
     $input = Read-Host "Bitte waehlen"
     switch ($input)
     {
        1 {Invoke-WebRequest -Uri $ubuntu16 -OutFile Ubuntu.appx -UseBasicParsing}      # Aktion Taste 1 
        2 {Invoke-WebRequest -Uri $ubuntu18 -OutFile Ubuntu.appx -UseBasicParsing}      # Aktion Taste 2 
		3 {Invoke-WebRequest -Uri $debian -OutFile Ubuntu.appx -UseBasicParsing}        # Aktion Taste 3 
		4 {Invoke-WebRequest -Uri $kali -OutFile Ubuntu.appx -UseBasicParsing}          # Aktion Taste 4 
        5 {Invoke-WebRequest -Uri $opensuse -OutFile Ubuntu.appx -UseBasicParsing}      # Aktion Taste 5 
     }       
}
until ($input -eq 'q')		# Beendet WLS-Setup Setup


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Ende -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host

Write-Host " "
Write-Host "           Nach dem Systemneustart die .appx Datei"
Write-Host "           (z.B. Ubuntu.appx) auf dem Desktop ausfuehren,"
Write-Host "           um WLS-Setup abzuschliessen."
Write-Host "           Die Datei kann anschliessend geloescht werden."

Start-Sleep -s 4			# 5 Sekunden Zeit zum Lesen

Restart-Computer -Force		# Startet Computer neu

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------