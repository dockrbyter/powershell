<#
AD-Abfrage.ps1
.DESCRIPTION

  Script zur Abfrage von AD-Userdaten
  
https://github.com/thelamescriptkiddiemax/powershell
#>
#------------------------------------------------------------------------------------------------------------------------------------
# AD-Properties hier eintragen

$props = @("DisplayName", "Name", "OtherName", "Surname")

#------------------------------------------------------------------------------------------------------------------------------------
# Admin-Rechte pruefen und ggf anfordern (UAC)

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

#------------------------------------------------------------------------------------------------------------------------------------
# Servermanager-Modul importieren, Remote Server Administrator Tools (RSAT) installieren

import-module servermanager
Add-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature

#------------------------------------------------------------------------------------------------------------------------------------
# User-Eingabe des Ziel-Pfads der CSV

Clear-Host
	$zielpfad = Read-Host "Bitte CSV Ziel-Pfad eingeben"

#------------------------------------------------------------------------------------------------------------------------------------
# Daten abfragen und in CSV speichern

Get-ADUser -Filter * -Properties $props | Select-Object $props | Export-CSV $zielpfad

#------------------------------------------------------------------------------------------------------------------------------------



<#
Active Directory: Get-ADUser Default and Extended Properties

https://social.technet.microsoft.com/wiki/contents/articles/12037.active-directory-get-aduser-default-and-extended-properties.aspx

AccountExpirationDate
AccountLockoutTime
AccountNotDelegated
AllowReversiblePasswordEncryption
BadLogonCount
CannotChangePassword
CanonicalName
Certificates
ChangePasswordAtLogon
City
CN
Company
Country
Created
Deleted
Department
Description
DisplayName
DistinguishedName
Division
DoesNotRequirePreAuth
EmailAddress
EmployeeID
EmployeeNumber
Enabled
Fax
GivenName
HomeDirectory
HomedirRequired
HomeDrive
HomePage
HomePhone
Initials
LastBadPasswordAttempt
LastKnownParent
LastLogonDate
LockedOut
LogonWorkstations
Manager
MemberOf
MNSLogonAccount
MobilePhone
Modified
Name
ObjectCategory
ObjectClass
ObjectGUID
Office
OfficePhone
OtherName
PasswordExpired
PasswordLastSet
PasswordNeverExpires
PasswordNotRequired
POBox
PostalCode
PrimaryGroup
ProfilePath
ProtectedFromAccidentalDeletion
SamAccountName
ScriptPath
ServicePrincipalNames
SID
SIDHistory
SmartcardLogonRequired
State
StreetAddress
Surname	String
Title	String
TrustedForDelegation
TrustedToAuthForDelegation
UseDESKeyOnly
UserPrincipalName
#>