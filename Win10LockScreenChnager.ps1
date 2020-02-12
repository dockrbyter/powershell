<#
Win10LockScreenChnager.ps1
.DESCRIPTION

    Windows 10 Profilbearbeitung

        Legt das Hintergrundbild des Anmeldebildschirms von Windows 10 fest

https://github.com/thelamescriptkiddiemax/powershell
#>


# Pfad zum Hintergrundbild - Bitte anpassen!
$IMGpfad =  "C:\Pfad\Zum\Image.jpg"


#-------------------------------------------------------------------------
# Registrypfad
$REGpfad = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"


Set-ItemProperty -Path $REGpfad -Name LockScreenImage -value $IMGpfad
