<#

Win10WallpaperChnager.ps1

Windows 10 Profilbearbeitung
Legt das Hintergrundbild  von Windows 10 fest

#>


# Pfad zum Hintergrundbild - Bitte anpassen!

$WALLPAPERpfad =  "C:\SIT\Wallpaper\Wallpaper.jpg"


#-------------------------------------------------------------------------
#   Bearbeitung

    reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d $WALLPAPERpfad /f
        Start-Sleep -s 1
            rundll32.exe user32.dll, UpdatePerUserSystemParameters, 0, $false
