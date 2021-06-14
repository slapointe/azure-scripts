param(
    [Parameter(Mandatory=$true)]
    [string[]]
    $SubscriptionName,
    [switch]
    $IncludePossibleOutputIpAddresses
)
$ErrorActionPreference = 'Stop'

$webApps = @()
$SubscriptionName | % {
    Write-Host ('Switching to subscription {0}' -f $_)
    $subContext = Set-AzContext -SubscriptionName  $_
    $webApps += Get-AzWebApp
}

$ipMatch = @(
    $webApps | % {
        $webAppName = $_.Name
        $ipAddresses = @($_.OutboundIpAddresses -split ',' | % { @{ IpAddress = $_; Type='Outbound' } })
        if($IncludePossibleOutputIpAddresses) {
            $ipAddresses += $_.PossibleOutboundIpAddresses -split ',' | % { @{ IpAddress = $_; Type='Possible' } }
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