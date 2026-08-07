using '../main.bicep'

param environment = 'dev'
param keyVaultName = 'kv-azbp-dev-weu-01'

param tags = {
	workload: 'azure-bicep-playground'
	owner: 'platform-team'
}

param keyVaultIpRules = []
param keyVaultSubnetIds = []

param keyVaultEnablePurgeProtection = true
param keyVaultSoftDeleteRetentionInDays = 90
param keyVaultPublicNetworkAccess = 'Enabled'
