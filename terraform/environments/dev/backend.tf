terraform {
  backend "azurerm" {
    resource_group_name  = "lucas"
    storage_account_name = "castoraccrxnttfstate"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}

