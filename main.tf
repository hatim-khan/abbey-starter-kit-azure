terraform {
  backend "http" {
    address        = "https://api.abbey.io/terraform-http-backend"
    lock_address   = "https://api.abbey.io/terraform-http-backend/lock"
    unlock_address = "https://api.abbey.io/terraform-http-backend/unlock"
    lock_method    = "POST"
    unlock_method  = "POST"
  }

  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "0.2.4"
    }

    azuread = {
      source = "hashicorp/azuread"
      version = "2.41.0"
    }
  }
}

provider "abbey" {
  # Configuration options
  bearer_auth = var.abbey_token
}
