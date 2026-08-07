# Azure Bicep Playground

This repository contains Azure infrastructure-as-code written in Bicep.

## Repository Structure

```text
.
|- README.md
|- docs/
|  |- architecture.md
|- infra/
|  |- main.bicep
|  |- modules/
|  |  |- key-vault.bicep
|  |- parameters/
|     |- dev.bicepparam
|     |- prod.bicepparam
```

## Infrastructure Layout

- `infra/main.bicep`
	- Entry point for resource-group scoped deployments.
	- Composes reusable modules from `infra/modules`.

- `infra/modules`
	- Reusable Bicep modules.
	- Current module inventory:
		- `key-vault.bicep`: deploys an Azure Key Vault with secure defaults.

- `infra/parameters`
	- Environment-specific parameter files:
		- `dev.bicepparam`
		- `prod.bicepparam`

## Current Module: Key Vault

`infra/modules/key-vault.bicep` provisions:

- `Microsoft.KeyVault/vaults`
- RBAC data-plane authorization enabled by default
- Soft delete retention support (7-90 days)
- Purge protection control
- Network ACLs with IP and subnet allow-lists
- Public network access control
- Standard/Premium SKU selection

Outputs:

- `id`
- `name`
- `vaultUri`

## How Main Template Uses Modules

`infra/main.bicep` currently references:

- `./modules/key-vault.bicep`

and exposes outputs:

- `keyVaultId`
- `keyVaultNameOut`
- `keyVaultUri`

## Deployments

Prerequisites:

- Azure CLI installed
- Logged in with `az login`
- Target subscription selected

Deploy dev:

```bash
az deployment group create \
	--resource-group <rg-name> \
	--parameters ./infra/parameters/dev.bicepparam
```

Deploy prod:

```bash
az deployment group create \
	--resource-group <rg-name> \
	--parameters ./infra/parameters/prod.bicepparam
```

## Conventions

- Add reusable modules to `infra/modules`.
- Wire module usage in `infra/main.bicep`.
- Keep environment values in `infra/parameters/dev.bicepparam` and `infra/parameters/prod.bicepparam`.
- Prefer secure defaults and parameterized settings.

## Naming Convention (CAF-aligned)

Use a predictable pattern for resource names:

- `kv-<workload>-<env>-<region>-<instance>`

Current examples:

- `kv-azbp-dev-weu-01`
- `kv-azbp-prod-weu-01`

Notes:

- Keep Key Vault names globally unique.
- Use only lowercase letters, numbers, and hyphens.
- Keep total length within Key Vault limits.
