#requires -modules Az.ResourceGraph
param(
    [string[]]
    $SubscriptionName,
    [switch]
    $IncludePossibleOutputIpAddresses
)
$ErrorActionPreference = 'Stop'

if($SubscriptionName)
{
    $subscriptions = Get-AzSubscription
    $matchedSubscriptions = $subscriptions | ? { $SubscriptionName -Contains $_.Name } | Select Id, Name

    if($matchedSubscriptions.Count -ne $SubscriptionName.Count) {
        $notMatchedSubs = ($SubscriptionName | ? { $subscriptions.Name -NotContains $_ }) -join ', '
        Write-Warning "The following subscriptions where not available/found in your Azure context and will be ignored: $notMatchedSubs"
    }
}

$queryParams = @{
    Query = "where type =~ 'Microsoft.Web/sites'
        | project subscriptionId,
            resourceGroup,
            name,
            outboundIpAddresses = properties.outboundIpAddresses,
            possibleOutboundIpAddresses = properties.possibleOutboundIpAddresses"
}
if($matchedSubscriptions) {
    $queryParams.Subscription = $matchedSubscriptions.Id
}

$webApps = @()
do {
    $webApps += Search-AzGraph @queryParams
    if($webApps.SkipToken) {
        $queryParams.SkipToken = $webApps.SkipToken
    }    
} while ($webApps.SkipToken)

$ipMatch = @(
    $webApps.Data | % {
        $webAppName = $_.name
        $ipAddresses = @($_.outboundIpAddresses -split ',' | % { @{ IpAddress = $_; Type='Outbound' } })
        if($IncludePossibleOutputIpAddresses) {
            $ipAddresses += $_.possibleOutboundIpAddresses -split ',' | % { @{ IpAddress = $_; Type='Possible' } }
        }
        $ipAddresses |  % {
            @{
                SiteName = $webAppName
                IpAddress = $_.IpAddress
                Type = $_.Type
            }
        }
    }
)

$ipMatch | Sort-Object {[System.Version]$_.IpAddress} | Group-Object {$_.IpAddress}, {$_.Type} | Select-Object Count, @{Name='IpAddress'; Expression={($_.Name -split ',')[0]}}, @{Name='Type'; Expression={($_.Name -split ',')[1]}}, @{Name='Sites'; Expression={,@($_.Group | % { $_.SiteName }) } }