# Demystifying Terraform
_"Hardcore".toCore(Infrastructure-as-Code) Tool_

Demo materials for my PowerShell Summit 2019 talk on Terraform

[Slides](.\Slides.pdf)

## Create an Azure Service Principle

```powershell
az ad sp create-for-rbac `
    --role contributor `
    --scopes /subscriptions/abc123 `
    --name terraform_sp
```