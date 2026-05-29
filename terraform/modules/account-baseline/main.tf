# Account Baseline Module
# Applies a consistent set of controls to every account in the landing zone.

variable "account_name" {
  description = "Human-friendly name of the account (used for tagging and naming)"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "environment_type" {
  description = "Type of environment (research, production, data, platform, security)"
  type        = string
  validation {
    condition     = contains(["research", "production", "data", "platform", "security"], var.environment_type)
    error_message = "environment_type must be one of: research, production, data, platform, security"
  }
}

variable "additional_tags" {
  description = "Extra tags to apply"
  type        = map(string)
  default     = {}
}

locals {
  common_tags = merge({
    "ManagedBy"         = "landing-zone"
    "AccountName"       = var.account_name
    "EnvironmentType"   = var.environment_type
    "CostCenter"        = "ai-platform"
  }, var.additional_tags)
}

# Enable key foundational services and settings for every account
resource "aws_iam_account_password_policy" "this" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
}

# Enforce IMDSv2 on all instances by default (very important for agent workloads)
resource "aws_ec2_instance_metadata_defaults" "this" {
  http_tokens                 = "required"
  http_put_response_hop_limit = 1
}

# Default encryption for EBS
resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}

# S3 account-level public access block
resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "common_tags" {
  value = local.common_tags
}
