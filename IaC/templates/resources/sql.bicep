@description('Customer prefix')
param prefix string

@description('Team suffix')
param suffix string

@description('Environment')
param environment string

@description('My SQL admin login password')
@secure()
param mySQLAdminLoginPassword string

@description('Location of the Resource Group. It uses the deployment\'s location when not provided.')
param location string = 'westeurope'

var appName = '${prefix}-dojo-coupon-${environment}-${suffix}'
var mySQLDatabaseName = 'hotel_coupon'


resource mysqlserver 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: appName
  location: location
  tags: {
  }
  sku: {
    capacity: 1
    family: 'Gen5'
    name: 'B_Gen5_1'
    tier: 'Basic'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: 'couponadmin'
    administratorLoginPassword: mySQLAdminLoginPassword
    sslEnforcement: 'Disabled'
    storageProfile: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
      storageMB: 5120
    }
    version: '5.7'
    createMode: 'Default'
  }
}

resource mysqlserver_database 'Microsoft.DBforMySQL/servers/databases@2017-12-01-preview' = {
  name: mySQLDatabaseName
  parent: mysqlserver
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}

resource mysqlserver_firewall 'Microsoft.DBforMySQL/servers/firewallRules@2017-12-01-preview' = {
  name: 'AllowAllWindowsAzureIps'
  parent: mysqlserver
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

