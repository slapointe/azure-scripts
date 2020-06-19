# ----------------- Az module compatible below

if((Get-Module -ListAvailable Az.Accounts)) {
    $subscription = (Get-AzContext -ErrorAction SilentlyContinue).Subscription
    if(-not $subscription) {
        $subscriptionMessage = "There is actually no selected Azure subscription."
    }
    else {
        $subscriptionMessage = ("Actually targeting Azure subscription: {0} - {1}." -f $subscription.Name, $subscription.Id)
    }
    $azureModule = Get-Module Az.Accounts
    if($azureModule) {
        Write-Verbose ('Using Azure PowerShell Az.Accounts v{0}' -f $azureModule.Version) -Verbose
    }
    Write-Verbose $subscriptionMessage -Verbose
}


# ----------------- AzureRM module compatible below

if(Get-Module -ListAvailable AzureRm.Profile) {
    $subscription = (Get-AzureRmContext -ErrorAction SilentlyContinue).Subscription
    if(-not $subscription) {
        $subscriptionMessage = "There is actually no selected Azure subscription."
    }
    else {
        $subscriptionMessage = ("Actually targeting Azure subscription: {0} - {1}." -f $subscription.Name, $subscription.Id)
    }
    $azureModule = Get-Module AzureRm.Profile
    if($azureModule) {
        Write-Verbose ('Using Azure PowerShell AzureRM.Profile v{0}' -f $azureModule.Version) -Verbose
    }
    Write-Verbose $subscriptionMessage -Verbose
}
