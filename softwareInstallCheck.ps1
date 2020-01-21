<#
softwareInstallCheck.ps1
.DESCRIPTION
	Prueft ob bestimmte Software (siehe Variablen)
	instaliert ist
#>
#--------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Variablen ------------------------------------------------------------------------------------------------------------------------------------------

$software = "Microsoft .NET Core Runtime - 2.0.0 (x64)"			# Welche Software?

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Installueberpruefung -------------------------------------------------------------------------------------------------------------------------------

$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $software }) -ne $null

If(-Not $installed) {
	Write-Host "'$software' ist NICHT installiert!";
} else {
	Write-Host "'$software' ist installiert."
}

Start-Sleep -s 3

#--------------------------------------------------------------------------------------------------------------------------------------------------------