# multi-region-dr/versions.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use a compatible version
    }
  }
  required_version = ">= 1.0.0"
}
