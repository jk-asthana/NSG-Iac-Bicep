resource staticWebsite 'Microsoft.Storage/storageAccounts/staticSites@2021-04-01' = {
  name: '${storageAccountName}/nsgdefault'
  parent: storageAccount
  properties: {
    indexDocument: 'index.html'
    errorDocument404Path: '404.html'
  }
}

output staticWebsiteUrl string = webapp.properties.endpoint