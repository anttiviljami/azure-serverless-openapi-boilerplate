# OpenAPI Azure Function Typescript Boilerplate

[![License](http://img.shields.io/:license-mit-blue.svg)](http://anttiviljami.mit-license.org)

Boilerplate project for a serverless API with automated OpenAPI specification on Azure Functions

This project is currently just me figuring out the best ways to do Serverless APIs in Azure with nice tooling.

## Features

- [ ] Local development with [Azure Functions Core Tools](https://github.com/Azure/azure-functions-core-tools)
- [ ] Azure infra deployment with [Terraform](https://www.terraform.io/downloads.html)
  - [x] Azure Function App with Linux Node.js runtime
  - [x] Azure Database for PostgreSQL
  - [ ] Azure Redis Cache
- [ ] Continuous deployment using ZIP deployment on Azure
- [ ] Automated OpenAPI specification

## Quick Start

Requirements:
- Node.js v10+
- [Azure Functions Core Tools](https://github.com/Azure/azure-functions-core-tools)
- Local PostgreSQL (docker-compose file included)
- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

```
source .env.sample # Set up environment variables
npm install
# docker-compose up --detach # PostgreSQL listening at port 5432
# npm run migrate # Set up database schema with knex migrations
npm run dev # Core Tools Start: http://localhost:9000
```

## Deploy

Requirements:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Terraform](https://www.terraform.io/downloads.html)

In Azure Portal, gather or create the following items:

- Subscription
  - ID
- Resource Group
  - Name
- Storage Account
  - Name
  - Access Key
- Blob Storage Container
  - Name

In your `.env` file, fill the missing environment variables.

```bash
# .env
export PROJECT_NAME=<unique name for your project>

export ARM_SUBSCRIPTION_ID=<Subscription ID>
export ARM_RESOURCE_GROUP=<Resource Group Name>
export ARM_ACCESS_KEY=<Storage Account Access Key>
```

Then source the file to load the environment variables.

```bash
source .env
```

If you wish, you can configure the terraform remote backend to a blob storage container.

See `terraform-backend.tf.sample`:

```terraform
terraform {
  backend "azurerm" {
    storage_account_name = "<Storage Account Name>"
    container_name = "<Blob Storage Container Name>"
    key = "terraform.tfstate"
  }
}
```

Init Terraform and deploy!

```sh
terraform init
terraform apply
```

## Publish

```sh
npm run build
func azure functionapp publish $PROJECT_NAME-<stage> --zip
```

