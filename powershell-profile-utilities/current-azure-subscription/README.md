# Current Azure subscription - PowerShell profile

Use this script to customize your PowerShell profile. It will enable you to display what Azure subscription is currently selected when you start a new PowerShell session. It can save you the shame of having to explain why you deleted VMs from a production subscription because you thought you where still in that development subscription ;)

 
If you already have custom logic in your PowerShell profile, simply append the content of this script to it. If you don't have any PS profile yet, simply save & rename this file as:

```%UserProfile%\My Documents\WindowsPowerShell\profile.ps1```

## Requirements
Tested with Az.Accounts Version 1.x

Tested with AzureRM.Profile Version 5.x & 6.x

## Output
```powershell
VERBOSE: Using Azure PowerShell Az.Accounts v1.3.1 
VERBOSE: Actually targeting Azure subscription: mycompany-dev - 53174c59-2689-4cf7-82c0-c9dcb4732bd9.
```