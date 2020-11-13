provider "aws" {
  version = "~> 3.0"
  region  = var.region
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}
