targetScope = 'resourceGroup'

@description('Environment name (e.g., dev, prod).')
param environment string

@description('Key Vault name. Must be globally unique.')
param keyVaultName string

@description('Optional location override. Defaults to resource group location.')
param location string = resourceGroup().location

@description('Optional tags merged with default tags.')
param tags object = {}

@description('Allowed source IPv4 ranges in CIDR notation for Key Vault firewall.')
param keyVaultIpRules array = []

@description('Allowed subnet resource IDs for Key Vault firewall.')
param keyVaultSubnetIds array = []

@description('Enable purge protection (recommended true, required in many production scenarios).')
param keyVaultEnablePurgeProtection bool = true

@description('Soft-delete retention in days for Key Vault.')
@minValue(7)
@maxValue(90)
param keyVaultSoftDeleteRetentionInDays int = 90

@description('Public network access setting for Key Vault.')
@allowed([
	'Enabled'
	'Disabled'
])
param keyVaultPublicNetworkAccess string = 'Enabled'

var defaultTags = {
	environment: environment
	managedBy: 'bicep'
}

module keyVault 'br/public:avm/res/key-vault/vault:0.14.0' = {
	params: {
		name: keyVaultName
		location: location
		tags: union(defaultTags, tags)
		enableRbacAuthorization: true
		enablePurgeProtection: keyVaultEnablePurgeProtection
		softDeleteRetentionInDays: keyVaultSoftDeleteRetentionInDays
		enableVaultForDeployment: false
		enableVaultForDiskEncryption: false
		enableVaultForTemplateDeployment: false
		networkAcls: {
			bypass: 'AzureServices'
			defaultAction: 'Deny'
			ipRules: [for ip in keyVaultIpRules: {
				value: ip
			}]
			virtualNetworkRules: [for subnetId in keyVaultSubnetIds: {
				id: subnetId
			}]
		}
		publicNetworkAccess: keyVaultPublicNetworkAccess
		sku: 'standard'
	}
}

output keyVaultId string = keyVault.outputs.resourceId
output keyVaultNameOut string = keyVault.outputs.name
output keyVaultUri string = keyVault.outputs.uri
