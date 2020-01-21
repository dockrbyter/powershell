<#

Win10ADUserPicChnager.ps1

Windows 10 Profilbearbeitung

Legt das Profilbild der Active Directory Benutzer im 
Anmeldebildschirm von Windows 10 fest
#>
#--- Variablen -----------------------------------------------------------------------------------

$DCsrv = "srv01.domain.local"           # Domaincontroller, z.B. srv01.domain.local
$UserNAME = "Max"                       # Benutzername, z.B "Max", oder * fuer alle Benutzer
$UserpicPFAD = "C:\Wallpaper\User.jpg"  # Pfad zum Profilbild, z.B. C:\Wallpaper\User.jpg
#----------------------------------------------------------------------------------------------------------

Set-ADUser $UserNAME -Replace @{thumbnailPhoto=$UserpicPFAD} -Server $DCsrv
