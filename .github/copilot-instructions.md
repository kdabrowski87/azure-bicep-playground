# Copilot Instructions

This repository contains Azure infrastructure code that is used to deploy and manage resources in Azure. The code is written in Bicep, a domain-specific language (DSL) for deploying Azure resources declaratively.

Principles: 
- Use Bicep to define and deploy Azure resources.
- GitHub Actions are used to automate the deployment of Bicep templates to Azure.
- parameters for dev should go into `infra/parameters/dev.bicepparam` and for prod into `infra/parameters/prod.bicepparam`.
- modules should go into the `modules` folder and be referenced from the main bicep file.
- Follow Azure CAF naming conventions

Avoid: 
- ARM templates, as Bicep is the preferred method for defining Azure resources in this repository.
- Terraform, as Bicep is the preferred method for defining Azure resources in this repository.

Prefer: 
- reusable modules 
- parameterized deployments
- secure defaults 
- content from Azure Verified Modules (AVM)
- AVM-first approach: when a suitable AVM exists, use it instead of custom resource definitions.

If AVM cannot be used:
- clearly explain why AVM is not suitable in this case (for example: no matching module, missing required feature, version constraint, or policy/compliance limitation).
- use a custom module in `infra/modules` with secure defaults and clear parameters.