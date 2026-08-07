@description('Name of the Key Vault.')
param name string

@description('Azure region for the Key Vault. Defaults to the current resource group location.')
param location string = resourceGroup().location

@description('Tags applied to the Key Vault.')
param tags object = {}

@description('Set to true to enable RBAC authorization for data plane access.')
param enableRbacAuthorization bool = true

@description('Set to true to enable purge protection (recommended for production).')
param enablePurgeProtection bool = true

@description('Soft-delete retention in days.')
@minValue(7)
@maxValue(90)
param softDeleteRetentionInDays int = 90

@description('Allowed source IPv4 ranges in CIDR notation. Empty array means no explicit IP allowlist.')
param ipRules array = []

@description('Allowed virtual network subnet resource IDs.')
param virtualNetworkSubnetIds array = []

@description('Controls public network access to the vault.')
@allowed([
	'Enabled'
	'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('SKU name for Key Vault.')
@allowed([
	'standard'
	'premium'
])
param skuName string = 'standard'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
	name: name
	location: location
	tags: tags
	properties: {
		tenantId: tenant().tenantId
		enableRbacAuthorization: enableRbacAuthorization
		enabledForDeployment: false
		enabledForDiskEncryption: false
		enabledForTemplateDeployment: false
		enablePurgeProtection: enablePurgeProtection
		softDeleteRetentionInDays: softDeleteRetentionInDays
		publicNetworkAccess: publicNetworkAccess
		networkAcls: {
			bypass: 'AzureServices'
			defaultAction: 'Deny'
			ipRules: [for ip in ipRules: {
				value: ip
			}]
			virtualNetworkRules: [for subnetId in virtualNetworkSubnetIds: {
				id: subnetId
			}]
		}
		sku: {
			family: 'A'
			name: skuName
		}
	}
}

output id string = keyVault.id
output name string = keyVault.name
output vaultUri string = keyVault.properties.vaultUri
