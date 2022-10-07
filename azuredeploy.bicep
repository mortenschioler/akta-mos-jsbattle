@description('Web app name')
@minLength(2)
param webAppName string = uniqueString(resourceGroup().id)

@description('Location for all resources')
param location string = resourceGroup().location

@description('The SKU of App Service Plan')
param sku string

param linuxFxVersion string = ''

@allowed(['linux', 'windows'])
param kind string = 'linux'

param reserved bool = false
param httpsOnly bool = true
param arrAffinity bool = true
param http2 bool = false

param appServiceName string = 'AppServicePlan-${webAppName}'

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
      appSettings: [
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
      }
      ]
    }
    serverFarmId: appService.id
  }
}
