@description('Customer prefix')
param prefix string

@description('Team suffix')
param suffix string

@description('Environment')
param environment string

@description('Storage account ID')
param storageAccountId string

@description('Workspace ID')
param workspaceId string

@secure()
param spring_datasource_password string

@secure()
param azure_keyvault_client_id string

@secure()
param azure_keyvault_client_key string

param app_service_object_id string

param service_principal_object_id string

@description('Location of the Resource Group. It uses the deployment\'s location when not provided.')
param location string = 'westeurope'

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: '${prefix}keyvaultcoupons${environment}${suffix}'
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    accessPolicies: []
    tenantId: subscription().tenantId
    sku: {
      name: 'premium'
      family: 'A'
    }
    networkAcls: null
  }
}

resource keyVault_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = {
  name: 'service'
  properties: {
    storageAccountId: storageAccountId
    workspaceId: workspaceId
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
            enabled: true
            days: 30
        }
      }
    ]
  }
  scope: keyVault
}

resource spring_datasource_username_secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'spring-datasource-username'
  parent: keyVault
  properties: {
    attributes: {
      enabled: true
    }
    value: 'couponadmin@${prefix}-dojo-coupon-${environment}-${suffix}'
  }
}

resource spring_datasource_password_secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'spring-datasource-password'
  parent: keyVault
  properties: {
    attributes: {
      enabled: true
    }
    value: spring_datasource_password
  }
}

resource azure_keyvault_client_id_secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'azure-keyvault-client-id'
  parent: keyVault
  properties: {
    attributes: {
      enabled: true
    }
    value: azure_keyvault_client_id
  }
}

resource azure_keyvault_client_key_secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'azure-keyvault-client-key'
  parent: keyVault
  properties: {
    attributes: {
      enabled: true
    }
    value: azure_keyvault_client_key
  }
}

resource access_policies 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'add'
  parent: keyVault
  properties: {
    accessPolicies: [
      {
        objectId: app_service_object_id
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
        tenantId: subscription().tenantId
      }
      {
        objectId: service_principal_object_id
        permissions: {
          secrets: [
            'get'
            'list'
            'set'
          ]
        }
        tenantId: subscription().tenantId
      }
    ]
  }
}
