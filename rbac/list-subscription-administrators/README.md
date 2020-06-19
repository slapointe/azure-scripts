# List Azure subscription's administrators

You'll find in this function an easy way to extract the list of administrators level accounts assigned on your Azure subscriptions within an authenticated PowerShell Azure session. It will look for Owner and everything with Administrator in the role names.

## Requirements
Tested with Az.Accounts Version 1.x

## Usage
```powershell
Connect-AzAccount  
  
# for all subscriptions in your context 
.\Get-AzSubscriptionAdministrators.ps1 
 
# for specific subscriptions 
.\Get-AzSubscriptionAdministrators.ps1 -SubscriptionName 'sub1', 'sub2'
```

 You will end up with an output in the like of:

 ```powershell
 Fetching administrators for subscription: sub1 
Fetching administrators for subscription: sub2 
 
Name                           Value 
----                           ----- 
subscription                   sub1 
admins                         {@{ObjectId=17b7df4e-bf37-469b-8708-7d2386efd850; SignInName=; DisplayName=MS-PIM; Sc... 
subscription                   sub2 
admins                         {@{ObjectId=17b7df4e-bf37-469b-8708-7d2386efd850; SignInName=; DisplayName=MS-PIM; Sc...
 ```