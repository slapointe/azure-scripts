[CmdletBinding()]
param(
    $ExpiresInDays = 90
)

$pageSize = 100
$iteration = 0
$searchParams = @{
    Query = 'Resources | where type =~ "Microsoft.Network/applicationGateways" | join kind=leftouter (ResourceContainers | where type=="microsoft.resources/subscriptions" | project subscriptionName=name, subscriptionId) on subscriptionId | project id, subscriptionId, subscriptionName, resourceGroup, name, sslCertificates = properties.sslCertificates | order by id'
    First = $pageSize    
}

$results = @()
do {
    $iteration += 1
    Write-Verbose "Iteration #$iteration"
    $results += Search-AzGraph @searchParams
    if ($results.SkipToken) {
        $searchParams.SkipToken = $results.SkipToken
    }
} while ($results.SkipToken)

$expirationDate = (Get-Date).AddDays($ExpiresInDays)
$results.Data | ForEach-Object {
    $record = $_

    $record.sslCertificates | ForEach-Object {
        $sslCertRecord = $_
        if (-not $_.properties.publicCertData) {
            $msg = 'Certificate {0} is linked to Key Vault secret: {1}. Certificate scanning is not supported in this scenario. You can leverage Azure Policy to do so.' -f $_.name, $_.properties.keyVaultSecretId
            Write-Warning $msg -Verbose
        }
        else {
            $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]([System.Convert]::FromBase64String($_.properties.publicCertData.Substring(60, $_.properties.publicCertData.Length - 60)))
            if ($cert.NotAfter -le $expirationDate) {
                @{
                    SubscriptionId    = $record.subscriptionId
                    SubscriptionName  = $record.subscriptionDisplayName
                    ResourceGroup     = $record.resourceGroup
                    Name              = $record.Name
                    Cert              = $cert
                    CertificateName   = $sslCertRecord.name
                    NotAfter          = $cert.NotAfter
                    Thumbprint        = $cert.Thumbprint
                    ImpactedListeners = , @($sslCertRecord.properties.httpListeners | ForEach-Object { ($_.id -split '/')[-1] } )
                }
 
            }       
        }
    }
}