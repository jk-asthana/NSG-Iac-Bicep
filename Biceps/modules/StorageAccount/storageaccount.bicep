@description('Azure Region for the resource')
param saLocation string = resourceGroup().location

@description('Business Group')
@allowed([
    'nhg'
])
param saBusinessgroup string

@description('Location of the resouce')
param saLoc string = location == 'northeeurope' ? 'ne' : 'we'

@description('Projcet of the resource')
@maxLength(10)
@minLength(3)
param saProject string

@description('Environment of the resource')
@allowed([
    'dev'
    'sit'
    'uat'
    'prd'
])
param saEnvironment string

@description('Replication mode of the Storage Account')
param saReplication string = contains(saType,'_LRS') ? 'lrs' : contains(saType,'_GRS') ? 'grs' : contains(saType,'_ZRS') ? 'zrs' : contains(saType,'_GZRS') ? 'gzrs' : contains(saType,'RAGRS') ? 'ragrs' : contains(saType,'RAGZRS') ? 'ragzrs' : ''

@description('Instance Count')
@maxLength(3)
param saInstance string

@description('Name of Storage Account')
@minLength(3)
@maxLength(24)
param saName string = '${businessgroup}${loc}${project}${environment}sa${replication}${instance}'


@description('Storage Account Type')
@allowed([
    'Standard_LRS'
    'Standard_GRS'
    'Standard_ZRS'
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GZRS'
    'Standard_RAGRS'
    'Standard_RAGZRS'
])
param saType string

@description('Public access')
param saPublicaccess
@allowed([
    'Enabled'
    'Disabled'
])

@description('Kind of Storage Account')
@allowed([
    'BlobStorage'
    'BlockBlobStorage'
    'FileStorage'
    'Storage'
    'StorageV2'
])

@description('Tags for the storage account')
param storageAccountTagValues object = {
    manage_by: ''
    cost_centre: ''
    project: ''
    business: ''
    service: ''
}

@description('Create Storage Account')
resource storage 'Microsoft.Storage/storageAccount@2022-05-01' = {
    name: saName
    kind: saKind
    location: saLoc
    
    sku: {
        name: saType
    }

    tags: storageAccountTagValues

    properties:{
        accessTier: 'Hot'
        allowBlobPublicAccess: saPublicaccess
        allowCrossTenanatReplication: false
        minimumTlsVersion: 'TLS1_2'
        allowShareKeyAccess: true
        encryption: {
            services: {
                blob: {
                    enabled : true
                    keyType: 'Account'
                }
                file: {
                    enabled : true
                    keyType: 'Account'
                }
                queue: {
                    enabled : true
                    keyType: 'Service'
                }
                table: {
                    enabled : true
                    keyType: 'Service'
                }                
            }            
        }
        largeFileSharesState: 'Enabled'
        publicNetworkAccess: saPublicaccess
    }
}

@description('Create file sService in Storage Account')
resource storagefileservice 'Microsoft.Storage/storageAccounts/fileServices@2022-05-01' = {
    name: 'nsgdefault'
    parent: storage
}

@description('Fileshares in the strorage account')
param filesshares array = ['']

@description('Create File shares in the storage account')
resource storagefileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = [for eachfileshare in fileshares : if (eachfileshare.name != '')] {
    name: eachfileshare.name
    parent: storagefileservice
    properties: {
        shareQuota: eachfileshare.quota
    }
}

@description('Blobs in storage account')
param containers array = ['']

@description('Create blob service')
resource blobservice 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
    name: '${storage.name}/nsgdefault'
}

@description('Created Blog Storage in the storage account')
resource storagecontainer 'Microsoft.Storage/storageAccounts/blobServices/container@2022-09-01' = [for eachcontainer in fileshares : if (eachcontainer.name != '')] {
    name: eachcontainer
    parent: blobservice    
}
    
@description('Export storage account resource ID')
output storageId string = storage.id 

@description('Export storage account name')
output storageName string = storage.name

