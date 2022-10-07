@description('Web app name')
@minLength(2)
param webAppName string = uniqueString(resourceGroup().id)

@description('Location for all resources')
param location string = resourceGroup().location

@description('The SKU of App Service Plan')
param sku string = 'F1'

@allowed(['linux', 'windows'])
param kind string = 'linux'

param linuxFxVersion string = 'NODE|lts'

param reserved bool = false
param httpsOnly bool = true
param arrAffinity bool = true
param http2 bool = false

var appServiceName = 'AppServicePlan-${webAppName}'

resource appService 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServiceName
  location: location
  properties: {
    reserved: reserved
  }
  sku: {
    name: sku
  }
  kind: kind
}

resource webApp 'Microsoft.Web/sites@2020-06-01' = {
  name: webAppName
  location: location
  properties: {
    reserved: reserved
    httpsOnly: httpsOnly
    clientAffinityEnabled: arrAffinity
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      http20Enabled: http2
    }
    serverFarmId: appService.id
  }
}
