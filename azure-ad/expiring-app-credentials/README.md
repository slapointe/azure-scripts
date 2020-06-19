# Audit expiring soon Azure AD application credentials (keys/certificates)

Too often you'll have developers or engineers coming to your desk in panic realizing their Azure AD application credential expired without them knowing it in advance. Be proactive instead of reactive and periodically audit soon to be expired Azure AD application credentials.

## Requirements
Tested with Azure PowerShell Az v1.x.x

## The problematic
Too often you'll have developers or engineers coming to your desk in panic realizing their Azure AD application credential expired without them knowing it in advance and it causes them downtime in their release pipeline, dev or worst, their production environment!

## What is proposed
Be proactive instead of reactive with this little script. Using this, you can get the list of your application in Azure AD that credentials are soon due to expire. You have full control over the desired time period for the credentials to be considered as expiring soon.

## Overview
This is an overview of the usage you can do of the script Get-AzADAppExpiringCredentials
```powershell
Connect-AzAccount 
 
# Will mark entries as ExpiringSoon if they ends 120 days from today  
$audit = & .\Get-AzADAppExpiringCredentials.ps1 -ExpiresInDays 120 -Verbose 
 
Gathering necessary information... 
VERBOSE: Fetching information for application ADAuditPlus Reporting 
VERBOSE: Fetching information for application app registration 
... 
Validating expiration data... 
Done. 
 
$audit | Group-Object -Property Status 
 
Count Name                      Group 
----- ----                      ----- 
   54 Expired                   {@{DisplayName=AutomationAccount_E+6heptOMzz8vX9ooTYFZq8DJYKweTDdIFrQmOo3BXs=; Objec... 
   11 ExpiringSoon              {@{DisplayName=AutomationAccountQwerty_e1yHxjl45+GwXIxG/mwqMnARwn5i6C5zSMAAIxZyzw... 
  173 Valid                     {@{DisplayName=ADAuditPlus Reporting; ObjectId=; ApplicationId=9db46068-49a0-45ae-b2... 
 
# or if you want the information in JSON you can do: 
$audit | ConvertTo-Json 
 
[ 
  { 
    "DisplayName": "AutomationAccountQwerty_e1yHxjl45", 
    "ObjectId": null, 
    "ApplicationId": { 
      "value": "e918c692-7aff-46f0-a3f6-488ded8f879a", 
      "Guid": "e918c692-7aff-46f0-a3f6-488ded8f879a" 
    }, 
    "KeyId": "baaf958b-bc2a-43ea-ab1f-0255662cd2bb", 
    "Type": "Password", 
    "StartDate": { 
      "value": "2016-05-11T14:55:30", 
      "DateTime": "Wednesday, May 11, 2016 2:55:30 PM" 
    }, 
    "EndDate": { 
      "value": "2018-05-11T14:55:30", 
      "DateTime": "Thursday, May 11, 2018 2:55:30 PM" 
    }, 
    "Status": "ExpiringSoon" 
  }, 
    ... 
] 
```