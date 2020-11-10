<#
(ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)

Powershell in 30 Minuten

    Ein Abenteuer mit Dustin und Max :D :D :D

    did = (ㆆ _ ㆆ) = durchaus interssierter dustin

(ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
#>









# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# I - Kommentare - Weil's easy ist



<#

Bla bla bla 
    ich bin ein Kommentar in einem Kommentarblock :D

        Klingt schmerzhaft - ist es auch        EXISTENCE IS PAIN

        Start-Process megaprozess loest hier absolut nichts aus... "...you have no power here..."


    $egalvariable = "ist hier auch super egal" 

#>

# Ich bin
# auch ein
# kommentar :D

# Auch hier gillt : $egalvariable = "ist hier auch super egal" 
















# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# II - Variablen - weil nix ohne Variablen

$egalvariable = "ist hier NICHT egal"                               # Variable mit String



$egalvariable                                                       # Ausgabe einer Variable




$unegalvariable = $egalvariable                                     # Variable mit Variable



Write-Host $unegalvariable                                          # Ausgabe einer Variable - mit Write-Host - BESSER :D




$netdomain =  ((Get-WmiObject Win32_ComputerSystem).Domain)         # Variable mit verschachteltem "Get-Befehl"



Write-Host $netdomain                                               # Ausgabe einer Variable    - Inhalt aus Befehl





$inputvariable = Read-Host 'Sachen fuer Variable eingeben!'         # Variable $inputvariable mit Read-Host befuellen
Pause                                                               # Pausiert Scriptausfuerung bis Enter gedrueckt wird
Write-Host $inputvariable                                           # Ausgabe befuellter Variablie $inputvariable







# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# II.I - Environment Variablen



Write-Host $ENV:UserName            # Ausgabe Username

Write-Host $ENV:computername        # Ausgabe Hostname

Write-Host $ENV:USERPROFILE         # Ausgabe Pfad zu User-Home



Get-ChildItem env:                  # Ausgabe Environment Variablen
















# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# III Get-Befehle

$netdomain =  ((Get-WmiObject Win32_ComputerSystem).Domain)                                 # Variable mit verschachteltem "Get-Befehl"
Write-Host $netdomain                                                                       # Ausgabe einer Variable    - Arbeitsgruppe / Domain - ohne "zeugs"




# Aufbau Get-Syntax:    Get-Was will ich haben? (WmiObject) (Win32_ComputerSystem)   
                        Get-WmiObject Win32_ComputerSystem                                  # Get-WmiObject     - Ungefilterte Ausgabe





# Aufbau Get-Syntax:    Get-Was will ich haben? (WmiObject) (Win32_ComputerSystem) . UNTERGRUPPE
(Get-WmiObject Win32_ComputerSystem).Domain                                                 # Ausgabe Arbeitsgruppe / Domain - ohne "zeugs"





Get-Date -Format "dd/MM/yyyy HH:mm"                                                         # Ausgabe Datum / Zeit



Get-Process explorer                                                                        # Stellt fest ob Process "Explorer" lauft






















# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# IV | Pipe, New-Item, Out-File
# Daten entgegen nehmen und weiter geben

#Trennstrich erzeugen
$didline = "(ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)"

$datumvariable = (Get-Date -Format "dd/MM/yyyy HH:mm")                                          # $datumvariable mit aktueller zeit fuellen
$dateilzielvariablemitsuperlangenname = "$ENV:USERPROFILE\Desktop"                              # Variable fuer Dateiziel (Desktop)
$txtfilename = "Logfile.txt"                                                                    # Variable fuer Dateiname in Perfektion (Concat)
$pfadfertig = "$dateilzielvariablemitsuperlangenname\$txtfilename"                              # Variable endgueltiger Dateiname


# New-Item Pfadangabe // $pfadfertig = $ENV:USERPROFILE\Desktop\Logfile.txt
New-Item $pfadfertig                                                                            # Logfile erstellen
$didline | Out-File -FilePath $pfadfertig -Append                                               # Trennstrich in Logfile schreiben








$datumvariable | Out-File -FilePath $pfadfertig -Append                                         # Zeitstempel in Logfile schreiben

#                           Zeug sammeln    PIPE (Uebergabe)        Verarbeiten

#Get - was? - Process - welcher? - explorer  |          Ausgabe an Datei 

                        Get-Process explorer | Out-File $pfadfertig -Append                     # Laufenden Prozess "Explorer" loggen


$didline | Out-File -FilePath $pfadfertig -Append                                               # Trennstrich in Logfile schreiben



# Moeglich waere auch         EINGABE | Verarbeitung-1 | Verarbeitung-2
# Oder                        $Variable | Verarbeitung
# Oder                        Get-Stuff | $Variable










# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# V Einfaches Logging-Script
# If, Concat (Stringmanipulation (Strings aneinander tackern)), Parameter


#       Easylogger.ps1
        <#
            Loggt laufenden Prozess
            
            Prueft Dateiexistenz, Erstellt ggf. Datei, Schreibt Logs in Datei
        #>

        #--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        #--- Variablen ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        $logordnername = "MEGALOGS"                                                                             # Name des Logordners - Wie soll der Ordner heissen in dem die Logs gespeichert werden?
        $fileziel = "$ENV:USERPROFILE\Desktop"                                                                  # Zielverzeichnis (Desktop) - Wo soll $logordnername gespeichert werden?

        $logprozess = "explorer"                                                                                # Prozess der ueberwacht werden soll

        #--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        $dtfilename = (Get-Date -Format "dd/MM/yyyy")                                                           # $dtfilename mit aktueller zeit fuellen (HEUTE) (Variable fuer Dateiname)
        $txtfilename = [System.String]::Concat("Logfile_", $dtfilename, ".txt")                                 # Variable fuer Dateiname in Perfektion (Concat)
        $ordnerpfad = "$fileziel\$logordnername"                                                                # Variable Orderpfad vollständig
        $pfadfertig = "$ordnerpfad\$txtfilename"                                                                # Variable endgueltiger Dateiname

        $didline = "(ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)"             # Abstandshalter $didline erzeugen   || Log Ueberschrift
        $enddid = "`n (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ) `n"                                                      # Abstandshalter $enddid erzeugen    || Log Endline

        #--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        #--- Verarbeitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        # Ertmal Dateiexistenz pruefen - mit IF NOT     || ! = NOT
        if(!(Test-Path $ordnerpfad))                                                                            # Wenn Ordner nicht vorhanden - $logordnername  || WENN(nicht (Test-Path $ordnerpfad)) || $ordnerpfad = C:\Users\CURRENTuser\Desktop\MEGALOGS
        {
            New-Item -Path $fileziel -Name $logordnername -ItemType "directory"                                 # Dann New-Item -Pfadparamer $Variable mit Pfad (C:\Users\CURRENTuser\Desktop) -Typenparameter Typ (directory - Ordner || leaf - Datei)
        }


        # Dann pruefen ob Datei existiert                                                                       # Wenn Datei nicht vorhanden - $pfadfertig  || WENN(nicht (Test-Path $pfadfertig -Pfadtyp leaf) || $pfadfertig = C:\Users\CURRENTuser\Desktop\MEGALOGS\Logfile_DATUMVONHEUTE.txt
        if(!(Test-Path $pfadfertig -PathType leaf))
        {
            New-Item $pfadfertig                                                                                # Dann New-Item C:\Users\CURRENTuser\Desktop\MEGALOGS\Logfile_DATUMVONHEUTE.txt     || Parameter koennen auch weggelassen werden. Manchmal MUESSEN sie mitgegeben werden (Beispiel Ordner), manchmal STOEREN sie - Try n' Error
        }


        # Vorbereitungen abgeschlossen - Pfad zur Datei und Datei exizistieren

        # Logfile mit Daten fuellen     || Daten werden mit dem Parameter -Append in die Datei geschrieben, andernfalls wird die Datei jedesmal überschrieben


        $didline | Out-File -FilePath $pfadfertig -Append                                                       # Trennstrich in Logfile schreiben
        
        $datumvariable = (Get-Date -Format "dd/MM/yyyy HH:mm:SS")                                               # $datumvariable mit aktueller zeit fuellen (JETZT) (Variable fuer Logfile) - Muss "intime" erfasst werden
        $datumvariable | Out-File -FilePath $pfadfertig -Append                                                 # Zeitstempel in Logfile schreiben
        
        
        Get-Process $logprozess | Out-File $pfadfertig -Append                                                  # Laufenden Prozess "Explorer" loggen
        
        
        $enddid | Out-File -FilePath $pfadfertig -Append                                                        # Trennstrich in Logfile schreiben
        

        #--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        #--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


        # Als .ps1 speichern und in Taskplaner hinterlegen - Fertig ist der Prozesslogger












# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# VI Zusammenfassung
# Was wissen wir bisher?
<#

Kommentare
- Kommentare beginnen mit einer #
- Kommentare koennen auch in einem Kommentarblock geschrieben werden


Varibalen
 - Varibalen koennen mit so ziehmlich allem gefuellt werden
 - Strings (Text), Befehle (z.B. Get-Date), Objekten (z.B. ((Get-WmiObject Win32_ComputerSystem).Domain) Also Domains, Computer, User, Netzwerkkaren, ...), andere Variablen, ..........


Get-Befehle
 - Mit Get-WASAUCHIMMER koennen alle moeglichen Informationen abgerufen werden
 - Es kommt vor (eigentlich fast immer), dass zu viel Output generiert wird
 - Der Output kann gefiltert werden
 - Der Output kann an eine Pipe weiter gegeben werden
 - Parameter koennen mitgegeben werden, muessen aber nicht unbedingt immer mitgegeben werden


Pipe
 - Nimmt Daten in irgend einer Form entgegen
 - Gibt diese Daten an irgendwas weiter (z.B. an Out-File)
 - Links von der Pipe - EINGABE        PIPE |         Rechts von der Pipe - Weiterverarbeitung


Parameter
 - Koennen mitgegeben werden
 - muessen nicht immer mitgegeben werden
 - ABSOLUT fallabhaengig


#>













# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# VII Weitere Befehle - Allgemeines
# Was ist das Gegenteil von Get? :D

Set-ItemProperty -Path C:\INFOS\Info.doc -Name IsReadOnly -Value $true                          # Set-ItemProperty - Eigenschaften eines Objekts veraendern - in diesem Fall die Datei Info.doc im Verzeichniss C:\INFOS auf schreibgeschuetzt setzen


Get-ChildItem C:\INFOS\Info.doc | Set-ItemProperty -Name IsReadOnly -Value $true                # Genau das gleiche, nur mit einer Pipe :D

#                   $true ist eine Systemvariable und gillt damit immer
#                   $false geht natuerlich auch ;)


Set-ADUser -Identity Dustin -HomePage 'https://maexico.ml'                                      # Legt fuer den AD-User Dustin https://maexico.ml als Startseite fuer den Defaultbrowser fest

#                   ADUser-Befehle gehen nur auf einem Windows Server,
#                   oder einem Windows Client, auf dem RSAT installiert ist!


Start-Process firefox.exe                                                                       # Startet den Prozess Firefox - Kein Positionsparameter noetig - Das System kennt seine installierte Software


.\UltraScript3k.ps1                                                                             # Startet das UltraScript3000



# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
# (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)   (ㆆ _ ㆆ)
