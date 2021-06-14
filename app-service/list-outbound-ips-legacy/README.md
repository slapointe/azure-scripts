# List App Service web apps outbound IP addresses (legacy)

You'll find in this function an easy way to extract the outbound IP addresses information used by all your App Services in your subscriptions by using the Azure Resource Graph, it is very fast compared to the old version scanning all subscription one at a time (50x faster for me)

## Requirements
Tested with Az.Accounts Version 2.2.x & Az.Websites 2.5.X

## Usage
```powershell
Connect-AzAccount 
 
.\Get-AppServiceWebAppsOutboundIpAddresses.ps1 -SubscriptionName 'mysub1','mysub2' -IncludePossibleOutputIpAddresses
```

You will end up with an output in the like of:

```powershell
Switching to subscription mysub1 
Switching to subscription mysub2 
 
Count   IpAddress       Type        Sites 
-----   ----            -----       ---- 
    2   13.85.17.60     Outbound  {sub1-bi-dev-as-webapp, sub2-bi-prod-as-webapp} 
    1   13.85.17.60     Possible  {sub3-bi-dev-as-webapp} 
    2   13.85.20.144    Outbound  {sub1-bi-prod-as-webapp, sub1-bi-dev-as-webapp} 
    1   13.85.20.144    Possible  {sub3-bi-dev-as-webapp} 
    2   13.85.22.206    Outbound  {sub2-bi-prod-as-webapp, sub1-bi-dev-as-webapp} 
    2   13.85.23.148    Outbound  {sub1-bi-dev-as-webapp, sub2-bi-prod-as-webapp} 
    2   13.85.23.243    Outbound  {sub1-bi-dev-as-webapp, sub2-bi-prod-as-webapp} 
    1   23.96.184.12    Outbound  {sub1-dev-functions-mmckydd} 
    1   23.96.184.209   Outbound  {sub1-dev-functions-mmckydd} 
    1   23.96.186.252   Outbound  {sub1-dev-functions-mmckydd} 
    1   23.96.187.50    Outbound  {sub1-dev-functions-mmckydd} 
    5   23.96.244.71    Outbound  {sub1-stg-webapp-web-n7wfdda, sub1-stg-functions-n7wfdda, sub1-stg-webapp-admin-n7wfdda, sub1-dev-ops-functions-stl4tn5...}
```