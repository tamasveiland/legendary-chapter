@description('Customer prefix')
param prefix string

@description('Team suffix')
param suffix string

@description('Environment')
param environment string

@description('Location of the Resource Group. It uses the deployment\'s location when not provided.')
param location string = 'westeurope'

var appName = '${prefix}-dojo-coupon-${environment}-${suffix}'
var keyVaultFullName = '${prefix}keyvaultcoupons${environment}${suffix}'
var mySQLDatabaseName = 'hotel_coupon'

var id = guid('seed')
var timeout = 120
var frequency = 300
var guidId = guid('seed')
var method = 'GET'
var url = 'https://${prefix}-dojo-coupon-${environment}-${suffix}.azurewebsites.net'
var expectedHttpStatusCode = 200
var version = '1.1'
var followRedirects = 'True'
var recordResults = 'True'
var cache = 'False'
var parseDependentRequests = 'False'
var ignoreHttpStatusCode = 'False'

resource appInsights 'Microsoft.Insights/components@2015-05-01' = {
  name: appName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource urlPingWebTest 'Microsoft.Insights/webtests@2015-05-01' = {
  name: 'ping'
  location: location
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
  }
  kind: 'ping'
  properties: {
    Configuration: {
      WebTest: '<WebTest xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Name="ping" Id="${id}" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="${timeout}" WorkItemIds="" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale=""> <Items> <Request Method="${method}" Guid="${guidId}" Version="${version}" Url="${url}" ThinkTime="0" Timeout="${timeout}" ParseDependentRequests="${parseDependentRequests}" FollowRedirects="${followRedirects}" RecordResult="${recordResults}" Cache="${cache}" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="${expectedHttpStatusCode}" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="${ignoreHttpStatusCode}" /> </Items> </WebTest>'
    }
    Description: 'Runs a classic URL ping test'    
    Enabled: true
    Frequency: frequency
    Kind: 'ping'
    Locations: [
      {
        Id: 'us-ca-sjc-azr'
      }
      {
        Id: 'us-il-ch1-azr'
      }
      {
        Id: 'us-va-ash-azr'
      }
      {
        Id: 'apac-hk-hkn-azr'
      }
      {
        Id: 'emea-au-syd-edge'
      }
    ]
    Name: 'ping'
    RetryEnabled: true 
    SyntheticMonitorId: 'ping-id'
    Timeout: timeout
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appName
  location: location
  kind: 'app'
  sku:{
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  properties: {
  }
}

resource site 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true
      javaContainer: 'TOMCAT'
      javaContainerVersion: '8.0'
      javaVersion: '1.8.0_172_ZULU'
    }
    httpsOnly: true
  }
}

resource site_appsettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'appsettings'
  kind: 'app'
  parent: site
  properties: {
    SPRING_DATASOURCE_URL: 'jdbc:mysql://${appName}.mysql.database.azure.com:3306/${mySQLDatabaseName}?verifyServerCertificate=true&useSSL=true&requireSSL=false'
    AZURE_KEYVAULT_URI: 'https://${keyVaultFullName}.vault.azure.net/'
    AZURE_APPLICATION_INSIGHTS_INSTRUMENTATION_KEY: appInsights.properties.InstrumentationKey
    SPRING_DATASOURCE_PASSWORD: '@Microsoft.KeyVault(SecretUri=https://${keyVaultFullName}.vault.azure.net/secrets/spring-datasource-password/)'
    SPRING_DATASOURCE_USERNAME: '@Microsoft.KeyVault(SecretUri=https://${keyVaultFullName}.vault.azure.net/secrets/spring-datasource-username/)'
    AZURE_KEYVAULT_CLIENT_ID: '@Microsoft.KeyVault(SecretUri=https://${keyVaultFullName}.vault.azure.net/secrets/azure-keyvault-client-id/)'
    AZURE_KEYVAULT_CLIENT_KEY: '@Microsoft.KeyVault(SecretUri=https://${keyVaultFullName}.vault.azure.net/secrets/azure-keyvault-client-key/)'
  }
}

output app_service_object_id string = site.identity.principalId
output appInsightsAppId string = appInsights.properties.AppId
