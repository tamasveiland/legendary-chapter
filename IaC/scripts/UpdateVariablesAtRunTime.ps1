param([Parameter(Mandatory=$True)] [string]$configPath,
          [Parameter(Mandatory=$true)]  [string]$keyVaultUri,
          [Parameter(Mandatory=$true)]  [string]$instrumentationKey,
          [Parameter(Mandatory=$true)]  [string]$sourceUrl,
          [Parameter(Mandatory=$true)]  [string]$appUrl,
          [Parameter(Mandatory=$true)]  [string]$principalId,
          [Parameter(Mandatory=$true)]  [string]$principalPass)


$target = Get-Content $configPath

$propertyUrl = "spring.datasource.url"

$propertKeyVaultUri = "azure.keyvault.uri"

$propertyInstrumentationKey = "azure.application-insights.instrumentation-key"

$propertyAppUrl = "app.url"

$propertyServiceId = "azure.keyvault.client-id"

$propertyServicePass = "azure.keyvault.client-key"

$patternUrl = "(?-s)(?<=$($propertyUrl)=).+"

$patternKeyVaultUri = "(?-s)(?<=$($propertKeyVaultUri)=).+"

$patternInstrumentationKey = "(?-s)(?<=$($propertyInstrumentationKey)=).+" 

$patternAppUrl = "(?-s)(?<=$($propertyAppUrl)=).+"

$patternServiceId = "(?-s)(?<=$($propertyServiceId)=).+"

$patternServicePass = "(?-s)(?<=$($propertyServicePass)=).+"

$valueUrl = $target | sls $patternUrl | %{$_.Matches} | %{$_.Value}

$valueKeyVaultUri = $target | sls $patternKeyVaultUri | %{$_.Matches} | %{$_.Value}

$valueInstrumentationKey = $target | sls $patternInstrumentationKey | %{$_.Matches} | %{$_.Value}

$valueAppUrl = $target | sls $patternAppUrl | %{$_.Matches} | %{$_.Value}

$valueServiceId =  $target | sls $patternServiceId | %{$_.Matches} | %{$_.Value}

$valueServicePass =  $target | sls $patternServicePass | %{$_.Matches} | %{$_.Value}

$newFile = get-content $configPath | ForEach-Object{

    $_.Replace($valueUrl,$sourceUrl).Replace($valueKeyVaultUri,$keyVaultUri).Replace($valueServicePrincipal,$servicePrincipal).Replace($valueAppUrl,$appUrl).Replace($valueInstrumentationKey,$instrumentationKey).Replace($valueServiceId,$principalId).Replace($valueServicePass,$principalPass)

}

$newFile | Set-Content $configPath


