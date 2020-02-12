<#
Windows10AppPurge.ps1
.DESCRIPTION

  Deinstalliert nervige Apps, die bei der Windows 10 Installation mitgelierfert werden und bei Bedarf
  Software wie den MS Store, oder Edge. Legt sich auch mit Cortana an...

    Schrottliste - Stand 15.10.2018

https://github.com/thelamescriptkiddiemax/powershell
#>



#--- Vorspiel ----------------------------------------------------------------------------------------------------------------------------------------------------------------

$REGPwerbung = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"

# Admin-Rechte pruefen und ggf anfordern (UAC)

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#--- Windows10AppPurge -----------------------------------------------------------------------------------------------------------------------------------------------------
# Bildschirmausgaben (das Menue darstellen)

function Show-Menu
{
    param (
        [string]$Title = ' Windows 10 App Purge '
    )
     Clear-Host
     

     Write-Host "  "	 
     Write-Host ">>=================================== $Title ===================================<<"    
     Write-Host "  "
     Write-Host "  1 > Bloatware entfernen            [Deinstalliert Apps wie Minecraft, Skype, Office holen,..."
     Write-Host "                                      (ggf. System neustarten und Vorgang wiederholen)]"
     Write-Host "  "
     Write-Host "  2 > Startmenue sortieren           [Entfernt im Startmenue angepinnte Apps und 
                                                       haengt Explorer, Word, Excel & Paint an]"
     Write-Host "  "
     Write-Host "  3 > Microsoft Store entfernen      [Deinstalliert den Microsoft Store]"
     Write-Host "  "
     Write-Host "  4 > ALLE Apps und Store enfernen   [Deinstalliert den Microsoft Store und ALLE Apps DAUERHAFT]"
     Write-Host "  "
     Write-Host "  5 > App Vorschlaege deaktivieren   [VERSUCHT App-Vorschlaege zu deaktivieren]"  
     Write-Host "  "
     Write-Host "  6 > Cortana deaktivieren           [VERSUCHT Cortana zu deaktivieren]"
     Write-Host "  "
}
do

# Tasteneingaben

{
     Show-Menu
     $input = Read-Host "Bitte waehlen"
     switch ($input)
     {
        1 {
            # Schrottliste

            Get-AppxPackage -AllUsers *3dbuilder* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *windowsphone* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *DrawboardPDF* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *getstarted* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *Facebook* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *feedback* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *zunevideo* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *bingfinance* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *solitairecollection* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *bingnews* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *messaging* | remove-appxpackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *officehub* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *onenote* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *skypeapp* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *bingsports* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *Asphalt8Airborne* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *CandyCrushSaga* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *minecraft* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *twitter* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *xboxIdentityprovider* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *xboxapp* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *people* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *adobe* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue
            
            Get-AppxPackage -AllUsers *xbox* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *HP* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *Hilfe* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *Kontakte* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *AdobeSystemsIncorporated* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue

            Get-AppxPackage -AllUsers *AdobePhotoshopElements* | Remove-AppxPackage -AllUsers -Verbose -ErrorAction SilentlyContinue


            } # Aktion Taste 1 Bloatware entfernen
        
        2 {
            
            function Pin-App { param(
            [string]$appname,
            [switch]$unpin
            )
            try{
            if ($unpin.IsPresent){
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{$_.Name -eq $appname}).Verbs() | Where-Object{$_.Name.replace('&','') -match 'From "Start" UnPin|Unpin from Start'} | ForEach-Object{$_.DoIt()}
            return "App '$appname' unpinned from Start"
            }else{
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{$_.Name -eq $appname}).Verbs() | Where-Object{$_.Name.replace('&','') -match 'To "Start" Pin|Pin to Start'} | ForEach-Object{$_.DoIt()}
            return "App '$appname' pinned to Start"
            }
            }catch{
            Write-Error "Error Pinning/Unpinning App! (App-Name correct?)"
            }
            }

            Pin-App "*" -unpin

            Pin-App "This*" -pin
            Pin-App "Word" -pin
            Pin-App "Excel" -pin
            Pin-App "Paint" -pin
          
          pause

          } # Aktion Taste 2 Apps an- und abhaengen 
                
        3 {
            
            Get-AppxPackage -AllUsers *windowsstore* | Remove-AppxPackage -AllUsers -Verbose
          
          } # Aktion Taste 3 Microsoft Store entfernen


        4 {
                  
            Get-AppXPackage | Remove-AppXPackage
            Get-AppXPackage -AllUsers | Remove-AppXPackage -AllUsers
            Get-AppXProvisionedPackage -AllUsers | Remove-AppXProvisionedPackage -AllUsers       
          
           } # Aktion Taste 3 Microsoft Store und ALLE Apps DAUERHAFT entfernen


         5 {
                    
                        IF(!(Test-Path $REGPwerbung))

                        {
        
                        New-Item -Path $REGPwerbung -Force | Out-Null

                        New-ItemProperty -Path $REGPwerbung -Name AicEnabled -Value Anywhere -Force | Out-Null}

                        ELSE {

                        New-ItemProperty -Path $REGPwerbung -Name AicEnabled -Value Anywhere -Force | Out-Null}          
          
              }         # Aktion Taste 3 App Vorschlaege deaktivieren


		6 {
                    $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"     
                    IF(!(Test-Path -Path $path)) {  
                    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search" }  
                    Set-ItemProperty -Path $path -Name "AllowCortana" -Value 1       
                    Stop-Process -name explorer # Explorer neustarten um Aenderungen durchzufuehren
           
           }    # Aktion Taste 5 Cortana deaktivieren

           }


}

until ($input -eq 'q') 

# Beendet Windows 10 App Purge

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
