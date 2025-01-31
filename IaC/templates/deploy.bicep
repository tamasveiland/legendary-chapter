targetScope = 'subscription'

@description('Customer prefix')
param prefix string

@description('Team suffix')
param suffix string

@description('My SQL admin login password')
@secure()
param mySQLAdminLoginPassword string

@description('Location of the Resource Group. It uses the deployment\'s location when not provided.')
param location string = 'westeurope'

@description('Environment')
param environment string

@secure()
param azure_keyvault_client_id string

@secure()
param azure_keyvault_client_key string

@description('Service principal Object ID')
param service_principal_object_id string

var resourceGroupName = '${prefix}-Dojo-Coupon-${environment}-${suffix}'
var la_resourceGroupName = '${prefix}-Dojo-Coupon-Log-Analytics-${suffix}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2019-05-01' = {
  location: location
  name: resourceGroupName
  properties: {}
}

module sql 'resources/sql.bicep' = {
  name: uniqueString(deployment().name, 'sql', location)
  scope: resourceGroup
  params: {
    prefix: prefix
    suffix: suffix
    environment: environment
    mySQLAdminLoginPassword: mySQLAdminLoginPassword
    location: resourceGroup.location

  }
}

module app_service 'resources/app-service.bicep' = {
  name: uniqueString(deployment().name, 'app_service', location)
  scope: resourceGroup
  params: {
    prefix: prefix
    suffix: suffix
    environment: environment
    location: resourceGroup.location
  }
}

resource la_resourceGroup 'Microsoft.Resources/resourceGroups@2019-05-01' = {
  location: location
  name: la_resourceGroupName
  properties: {}
}

module log_analytics 'resources/log-analytics.bicep' = {
  name: uniqueString(deployment().name, 'log_analytics', location)
  scope: la_resourceGroup
  params: {
    prefix: prefix
    suffix: suffix
    location: la_resourceGroup.location
  }
}

module keyvault 'resources/keyvault.bicep' = {
  name: uniqueString(deployment().name, 'keyvault', location)
  scope: resourceGroup
  params: {
    prefix: prefix
    suffix: suffix
    environment: environment
    storageAccountId: log_analytics.outputs.storageAccountId
    workspaceId: log_analytics.outputs.workspaceId
    spring_datasource_password: mySQLAdminLoginPassword
    azure_keyvault_client_id: azure_keyvault_client_id
    azure_keyvault_client_key: azure_keyvault_client_key
    app_service_object_id: app_service.outputs.app_service_object_id
    service_principal_object_id: service_principal_object_id
    location: resourceGroup.location
  }
}

output appInsightsAppId string = app_service.outputs.appInsightsAppId
