@description('CDN Profile Name')
param cdnProfileName string

@description('CDN Endpoint Name')
param cdnEndpointName string

@description('Storage account name for CDN')
param storageAccountName string

@description('Locaiton for CDN')
param location string

@description('CDN Profile Creation Module')
module cdn '../modules/CDN/cdn.bicep' = {
  name: 'CDN-Profile'
  params: {
    cdnProfileName: cdnProfileName
    cdnEndpointName: cdnEndpointName
    storageAccountName: storageAccountName
    location: location
  }
}