# Example: Full Landing Zone Composition
# This is a simplified representation of how the modules would be composed.

module "organization" {
  source = "../../modules/organization-setup"
  # ... configuration
}

module "security_ou" {
  source = "../../modules/ou"
  name   = "Security"
  # ...
}

# Apply strong baseline to every account
module "account_baselines" {
  source = "../../modules/account-baseline"

  for_each = local.all_accounts

  account_name     = each.value.name
  account_id       = each.value.id
  environment_type = each.value.type
}

# Centralized SCPs
module "scp_library" {
  source = "../../modules/scp-library"

  # Attach different policy sets to different OUs
  research_ou_id   = local.research_ou_id
  production_ou_id = local.production_ou_id
}

# This is intentionally high-level. The real value lives in the modules.
