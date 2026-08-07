using '../main.bicep'

param environment = 'prod'
param keyVaultName = 'kv-azbp-prod-weu-01'

param tags = {
	workload: 'azure-bicep-playground'
	owner: 'platform-team'
}

param keyVaultIpRules = []
param keyVaultSubnetIds = []

param keyVaultEnablePurgeProtection = true
param keyVaultSoftDeleteRetentionInDays = 90
param keyVaultPublicNetworkAccess = 'Disabled'
