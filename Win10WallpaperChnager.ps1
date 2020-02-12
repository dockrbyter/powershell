<#
Win10WallpaperChnager.ps1
.DESCRIPTION

    Windows 10 Profilbearbeitung

        Legt das Hintergrundbild  von Windows 10 fest

https://github.com/thelamescriptkiddiemax/powershell
#>
#--- Variablen ----------------------------------------------------------------------------------------------

$WALLPAPERpfad =  "C:\Wallpaper\Wallpaper.jpg"      # Pfad zum Hintergrundbild

#--- Verarbeitung -------------------------------------------------------------------------------------------

    reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d $WALLPAPERpfad /f
        Start-Sleep -s 1
            rundll32.exe user32.dll, UpdatePerUserSystemParameters, 0, $false
