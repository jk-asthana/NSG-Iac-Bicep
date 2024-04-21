@description('Storage Account Details')
param storageAccountDetails object

@description('Storage Account Tag values')
param storageAccountTagValues object

@description('Storage Account Creation Details')
module storageAccount '../modules/StorageAccount/storageaccount.bicep' = {
    scope: resourceGroup(storageAccountDetails.saResourceGroup)
    name: 'Storage-Account'
    params: {
        fileshares: storageAccountDetails.saFileshares
        containers: storageAccountDetails.saContainers
        publicaccess: storageAccountDetails.saPublicaccess
        businessgroup: storageAccountDetails.saBusinessgroup
        environment: storageAccountDetails.saEnvironment
        instance: storageAccountDetails.saInstance
        project: storageAccountDetails.saProject
        type: storageAccountDetails.saType
        kind: storageAccountDetails.j=saKind
        tagvalues: storageAccountTagValues
    }
}