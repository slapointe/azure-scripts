[CmdletBinding()]
param(
    $ExpiresInDays = 90
)

$pageSize = 100
$iteration = 0
$searchParams = @{
    Query = 'where type =~ "Microsoft.Network/applicationGateways" | project id, subscriptionId, subscriptionDisplayName, resourceGroup, name, sslCertificates = properties.sslCertificates | order by id'
    First = $pageSize
    Include = 'displayNames'
}

$results = do {
    $iteration += 1
    Write-Verbose "Iteration #$iteration"
    $pageResults = Search-AzGraph @searchParams
    $searchParams.Skip += $pageResults.Count
    $pageResults
    Write-Verbose $pageResults.Count
} while ($pageResults.Count -eq $pageSize)

$90daysfromNow = (Get-Date).AddDays($ExpiresInDays)
$results | % {
    $record = $_

    $record.sslCertificates | % {
        $sslCertRecord = $_
        $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]([System.Convert]::FromBase64String($_.properties.publicCertData.Substring(60,$_.properties.publicCertData.Length-60)))
        if ($cert.NotAfter -le $90daysfromNow) {
            @{
                SubscriptionId = $record.subscriptionId
                SubscriptionName = $record.subscriptionDisplayName
                ResourceGroup = $record.resourceGroup
                Name = $record.Name
                Cert = $cert
                CertificateName = $sslCertRecord.name
                NotAfter = $cert.NotAfter
                Thumbprint = $cert.Thumbprint
                ImpactedListeners = ,@($sslCertRecord.properties.httpListeners | ForEach-Object { ($_.id -split'/')[-1] } )
            }
        }
    }
}