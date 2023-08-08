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

provider "azuread" {
  use_cli = false
}

provider "abbey" {
  # Configuration options
  bearer_auth = var.abbey_token
}

resource "azuread_group" "quickstart_group" {
  display_name = "quickstart_group"
  security_enabled = true
}

resource "abbey_identity" "dev_user" {
  abbey_account = "hat@abbey.io" #CHANGEME
  source = "azure"
  metadata = jsonencode(
    {
      upn = "hat_abbey.io#EXT#@hatabbey.onmicrosoft.com" #CHANGEME
    }
  )
}


resource "abbey_grant_kit" "azure_quickstart_group" {
  name = "azure_quickstart_group"
  description = <<-EOT
    Grants access to our Azure quickstart group.
  EOT

  workflow = {
    steps = [
      {
        reviewers = {
          one_of = ["hat@abbey.io"] # CHANGEME
        }
      }
    ]
  }

  policies = [
    { bundle = "github://hatim-khan/abbey-starter-kit-azure/policies" } # CHANGEME
  ]

  output = {
    # Replace with your own path pointing to where you want your access changes to manifest.
    # Path is an RFC 3986 URI, such as `github://{organization}/{repo}/path/to/file.tf`.
    location = "github://hatim-khan/abbey-starter-kit-azure/access.tf" # CHANGEME
    append = <<-EOT
      resource "azuread_group_member" "group_member" {
        group_object_id  = "${azuread_group.abbey_read_group.id}"
        member_object_id = "${data.system.abbey.identities.azure.upn}"
      }
    EOT
  }
}

