@description('Customer prefix')
param prefix string

@description('Team suffix')
param suffix string

@description('Location of the Resource Group. It uses the deployment\'s location when not provided.')
param location string = 'westeurope'

resource la 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: '${prefix}Dojo-Coupon-Log-Analytics${suffix}'
  location: location
  tags: {}
  properties: {
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 365
    sku: {
      name: 'pergb2018'
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
  }
}

resource insights_config 'Microsoft.OperationalInsights/workspaces/storageInsightConfigs@2020-08-01' = {
  name: '${prefix}dojocouponworkspace${suffix}'
  parent: la
  properties: {
    containers: []
    storageAccount: {
      id: sta.id
      key: sta.listKeys().keys[0].value
    }
    tables: [
      'WADWindowsEventLogsTable'
      'WADETWEventTable'
      'WADServiceFabric*EventTable'
      'LinuxsyslogVer2v0'
    ]
  }
}

resource sta 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${prefix}dojocouponskv${suffix}'
  location: location
  tags: {}
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: true
    networkAcls: {
        bypass: 'AzureServices'
        virtualNetworkRules: []
        ipRules: []
        defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
        services: {
            file: {
                keyType: 'Account'
                enabled: true
            }
            blob: {
                keyType: 'Account'
                enabled: true
            }
        }
        keySource: 'Microsoft.Storage'
    }
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: sta
  properties: {
    containerDeleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
    cors: {
      corsRules: []
    }
  }
}

resource insights_logs_auditevent 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'insights-logs-auditevent'
  parent: blob
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    immutableStorageWithVersioning: {
      enabled: false
    }
    metadata: {}
    publicAccess: 'None'
  }
}

resource table 'Microsoft.Storage/storageAccounts/tableServices@2022-05-01' = {
  name: 'default'
  parent: sta
  properties: {
    cors: {
      corsRules: [
      ]
    }
  }
}

output workspaceId string = la.id
output storageAccountId string = sta.id
