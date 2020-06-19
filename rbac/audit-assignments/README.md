# Audit Azure subscription RBAC assignments
If you need to audit/log Azure permissions, this is it. I created this script to help perform a RBAC audit for a Azure subscription. This script resolves all RBAC assignments, then expand every group to retain only resolved users. 

It is build so that you can take the output and do whatever you want with it after, whenever it's convert it to JSON, CSV, XML.

Here are 2 invocation examples and their outputs

## Usage
```powershell
Connect-AzureRmAccount 
 
Set-AzureRmContext -Subscription 'Your Subscription' 
 
# Perform an audit grouped by users 
$rbacAuditGroupedByUser = Invoke-AzureRmSubscriptionRBACAudit.ps1 -GroupRolesByUser 
 
#output the result as-is 
$rbacAuditGroupedByUser 
 
Count Name                                     RoleDefinitions                                                               ParentGroup 
----- ----                                          ---------------                                                                 ----------- 
    2 FirstName1 LastName1              Contributor, Reader                                                           
    1 azure-test@mycompany.com      AccountAdministrator                                                                        
    1 FirstName2 LastName2              Owner                                                                                       
    4 FirstName3 LastName3              Contributor, Reader, Owner, Owner       
```

```powershell
Connect-AzureRmAccount 
 
Set-AzureRmContext -Subscription 'Your Subscription' 
 
# Perform an audit grouped by users 
$rbacAudit = Invoke-AzureRmSubscriptionRBACAudit.ps1  
 
#output the result as-is 
$rbacAudit 
 
Id                 : 4506482f-23a0-4820-850b-06219f704739 
DisplayName        : FirstName1 LastName1 
ParentGroup        : {Id, DisplayName} 
RoleDefinitionName : Reader 
Scope              : /subscriptions/11111111-1111-1111-1111-111111111111 
CanDelegate        : False 
 
Id                 : dc37e4bd-1811-4b5e-ba5e-1322ff5ac29d 
DisplayName        : FirstName2 LastName2 
ParentGroup        : {Id, DisplayName} 
RoleDefinitionName : Owner 
Scope              : /subscriptions/11111111-1111-1111-1111-111111111111 
CanDelegate        : False 
 
Id                 : 8a173eb5-52a4-4a5b-b6ae-aefc3dac7489 
DisplayName        : FirstName3 LastName3 
ParentGroup        : {Id, DisplayName} 
RoleDefinitionName : Reader 
Scope              : /subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/stg 
CanDelegate        : False 
 
Id                 : 4e13ae9c-7e3b-49e4-a49e-e81c2dd21151 
DisplayName        : FirstName4 LastName4 
ParentGroup        : {Id, DisplayName} 
RoleDefinitionName : Contributor 
Scope              : /subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/stg/providers/Microsoft.Insights/components/stg-ai-app-qjkgqezdtfjr4 
CanDelegate        : False 
 
#output the result as JSON 
$rbacAudit | ConvertTo-Json -Depth 5 
 
[ 
    { 
        "Id":  "4506482f-23a0-4820-850b-06219f704739", 
        "DisplayName":  "FirstName1 LastName1", 
        "ParentGroup":  { 
                            "Id":  "9cb7e0c1-0513-441b-b484-8b55761694fe", 
                            "DisplayName":  "SecurityGroupName1" 
                        }, 
        "RoleDefinitionName":  "Reader", 
        "Scope":  "/subscriptions/11111111-1111-1111-1111-111111111111", 
        "CanDelegate":  false 
    }, 
    ... 
]
```