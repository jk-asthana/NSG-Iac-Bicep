param cdnProfileName string
param cdnEndpointName string
param storageAccountName string
param location string

resource cdnProfile 'Microsoft.Cdn/profiles@2021-10-01' = {
  name: cdnProfileName
  location: location
  properties: {
    sku: {
      name: 'Standard_Verizon'
    }
  }
}

resource cdnEndpoint 'Microsoft.Cdn/profiles/endpoints@2021-10-01' = {
  name: '${cdnProfileName}/${cdnEndpointName}'
  parent: cdnProfile
  properties: {
    originHostHeader: '${storageAccountName}.blob.core.windows.net'
    originPath: '/'
    origins: [
      {
        name: 'storage'
        properties: {
          hostName: '${storageAccountName}.blob.core.windows.net'
        }
      }
    ]
    isHttpAllowed: false
    isHttpsAllowed: true
    optimizationType: 'GeneralWebDelivery'
    queryStringCachingBehavior: 'IgnoreQueryString'
    contentTypesToCompress: [
      'text/html'
      'text/css'
      'application/javascript'
      'application/json'
    ]
  }
}
