module staticWebsite '../modules/WebApp/webapp.bicep' = {
  name: 'staticWebsiteModule'
  params: {
    storageAccountName: StorageAccount.outputs.storageAccountName
  }
}