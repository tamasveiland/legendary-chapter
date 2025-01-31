param
(
    [Parameter(Mandatory=$True)] [string]$datasourceUrl,
    [Parameter(Mandatory=$true)] [string]$appInsightsInstrumentationKey,
    [Parameter(Mandatory=$true)] [string]$azureKeyVaultUrl,
    [Parameter(Mandatory=$true)] [string]$azureKeyVaultClientId,
    [Parameter(Mandatory=$true)] [string]$azureKeyVaultClientKey
)

[Environment]::SetEnvironmentVariable("SPRING_DATASOURCE_URL", $datasourceUrl, "Machine")
[Environment]::SetEnvironmentVariable("AZURE_APPLICATION_INSIGHTS_INSTRUMENTATION_KEY", $appInsightsInstrumentationKey, "Machine")
[Environment]::SetEnvironmentVariable("AZURE_KEYVAULT_URI", $azureKeyVaultUrl, "Machine")
[Environment]::SetEnvironmentVariable("AZURE_KEYVAULT_CLIENT_ID", $azureKeyVaultClientId, "Machine")
[Environment]::SetEnvironmentVariable("AZURE_KEYVAULT_CLIENT_KEY", $azureKeyVaultClientKey, "Machine")

# Restart tomcat
Stop-Service -Name 'Tomcat9' -Force -Verbose
Start-Service -Name 'Tomcat9' -Verbose


