<#

Win10ADUserPicChnager.ps1

Windows 10 Profilbearbeitung

Legt das Profilbild der Active Directory Benutzer im 
Anmeldebildschirm von Windows 10 fest

#>

#                   BITTE VARIABLEN ANPASSEN

# Domaincontroller                          (z.B. srv01.domain.local)

$DCsrv = "srv01.domain.local"


# Benutzername                              (z.B: Maximilian, oder * fuer alle Benutzer)

$UserNAME = "Maximilian"


# Pfad zum Profilbild                       (z.B. C:\SIT\Wallpaper\User.jpg)

$UserpicPFAD = "C:\SIT\Wallpaper\User.jpg"


#----------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------

Set-ADUser $UserNAME -Replace @{thumbnailPhoto=$UserpicPFAD} -Server $DCsrv
 