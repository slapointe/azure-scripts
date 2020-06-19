#requires -Version 3.0 -Modules AzureRM.Resources
param(
    [switch]
    $GroupRolesByUser
)
$ErrorActionPreference = 'Stop'

function Resolve-AzureAdGroupMembers 
{
    param(
        [guid]
        $GroupObjectId,
        $GroupList = (Get-AzureRmADGroup)
    )
    
    $VerbosePreference = 'continue'
    Write-Verbose -Message ('Resolving {0}' -f $GroupObjectId)
    $group = $GroupList | Where-Object -Property Id -EQ -Value $GroupObjectId
    $groupMembers = Get-AzureRmADGroupMember -GroupObjectId $GroupObjectId
    Write-Verbose -Message ('Found members {0}' -f ($groupMembers.DisplayName -join ', '))
    $parentGroup = @{
        Id          = $group.Id
        DisplayName = $group.DisplayName
    }
    $groupMembers |
    Where-Object -Property Type -NE -Value Group |
    Select-Object -Property Id, DisplayName, @{
        Name       = 'ParentGroup'
        Expression = { $parentGroup }
    }
    $groupMembers |
    Where-Object -Property type -EQ -Value Group |
    ForEach-Object -Process {
        Resolve-AzureAdGroupMembers -GroupObjectId $_.Id -GroupList $GroupList 
    }
}

$roleAssignments = Get-AzureRmRoleAssignment -IncludeClassicAdministrators

$members = $roleAssignments | ForEach-Object -Process {
    Write-Verbose -Message ('Processing Assignment {0}' -f $_.RoleDefinitionName)
    $roleAssignment = $_
    
    if($roleAssignment.ObjectType -eq 'Group') 
    {
        Resolve-AzureAdGroupMembers -GroupObjectId $roleAssignment.ObjectId `
        | Select-Object -Property Id,
            DisplayName,
            ParentGroup, @{
                Name       = 'RoleDefinitionName'
                Expression = { $roleAssignment.RoleDefinitionName }
            }, @{
                Name       = 'Scope'
                Expression = { $roleAssignment.Scope }
            }, @{
                Name       = 'CanDelegate'
                Expression = { $roleAssignment.CanDelegate }
            }
    }
    else 
    {
        $roleAssignment | Select-Object -Property @{
                Name       = 'Id'
                Expression = { $_.ObjectId }
            },
            DisplayName, 
            @{
                Name       = 'RoleDefinitionName'
                Expression = { $roleAssignment.RoleDefinitionName }
            },
            Scope, 
            CanDelegate
    }
}

if($GroupRolesByUser) 
{
    $members |
    Sort-Object -Property DisplayName, RoleDefinitionName `
    |
    Group-Object -Property DisplayName `
    |
    Select-Object -Property Count,
        Name,
        @{
            Name       = 'RoleDefinitions'
            Expression = { $_.Group.RoleDefinitionName -join ', ' }
        },
        ParentGroup
}
else 
{
    $members
}
