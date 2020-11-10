<#
(ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)

Powershell in 30 Minuten

    Ein Abenteuer mit Dustin und Max :D :D :D


(ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
#>









# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# I - Kommentare - Weil easy ist



<#

Bla bla bla 
    ich bin ein Kommentar in einem Kommentarblock :D

        Klingt schmerzhaft - ist es auch

        Start-Process megaprozess loest hier absolut nichts aus... "...you have no power here..."


    $egalvariable = "ist hier auch super egal" 

#>

# Ich bin
# auch ein
# kommentar :D

# Auch hier gillt : $egalvariable = "ist hier auch super egal" 
















# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# II - Variablen - weil nix ohne Variablen

$egalvariable = "ist hier NICHT egal"  # Variable mit String



$egalvariable                           # Ausgabe einer Variable




$unegalvariable = $egalvariable         # Variable mit Variable



Write-Host $unegalvariable              # Ausgabe einer Variable - mit Write-Host - BESSER :D




$netdomain =  ((Get-WmiObject Win32_ComputerSystem).Domain)         # Variable mit verschachteltem "Get-Befehl"



Write-Host $netdomain                   # Ausgabe einer Variable    - Inhalt aus Befehl






# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# II.I - Environment Variablen



Write-Host $ENV:UserName            # Ausgabe Username

Write-Host $ENV:computername        # Ausgabe Hostname

Write-Host $ENV:USERPROFILE         # Ausgabe Pfad zu User-Home



dir env:                            # Ausgabe Environment Variablen














# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# III Get-Befehle

$netdomain =  ((Get-WmiObject Win32_ComputerSystem).Domain)         # Variable mit verschachteltem "Get-Befehl"
Write-Host $netdomain                                               # Ausgabe einer Variable    - Arbeitsgruppe / Domain - ohne "zeugs"




# Aufbau Get-Syntax:    Get-Was will ich haben? (WmiObject) (Win32_ComputerSystem)   
                        Get-WmiObject Win32_ComputerSystem                                  # Get-WmiObject     - Ungefilterte Ausgabe





# Aufbau Get-Syntax:    Get-Was will ich haben? (WmiObject) (Win32_ComputerSystem) . UNTERGRUPPE
(Get-WmiObject Win32_ComputerSystem).Domain                         # Ausgabe Arbeitsgruppe / Domain - ohne "zeugs"





Get-Date -Format "dd/MM/yyyy HH:mm"                                 # Ausgabe Datum / Zeit



Get-Process explorer                                                # Stellt fest ob Process "Explorer" lauft












# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# III | Pipe
# Datem entgegen nehmen und weiter geben

#Trennstrich erzeugen
 = "(ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)"

$datumvariable = (Get-Date -Format "dd/MM/yyyy HH:mm")                                          # $datumvariable mit aktueller zeit fuellen
$dateilzielvariablemitsuperlangenname = "$ENV:USERPROFILE\Desktop"                              # Variable fuer Dateiziel (Desktop)
$txtfilename = "Logfile.txt"                                                                    # Variable fuer Dateiname in Perfektion (Concat)
$pfadfertig = "$dateilzielvariablemitsuperlangenname\$txtfilename"                              # Variable endgueltiger Dateiname


# New-Item Pfadangabe // $pfadfertig = $ENV:USERPROFILE\Desktop\Logfile.txt
New-Item $pfadfertig                                                                            # Logfile erstellen









$datumvariable | Out-File -FilePath $pfadfertig -Append                                         # Zeitstempel in Logfile schreiben

#                           Zeug sammeln    PIPE (Uebergabe)        Verarbeiten

#Get - was? - Process - welcher? - explorer  |          Ausgabe an Datei 

                        Get-Process explorer | Out-File $pfadfertig -Append                     # Laufenden Prozess "Explorer" loggen


$trennstrich | Out-File -FilePath $pfadfertig -Append                                         # Trennstrich in Logfile schreiben


