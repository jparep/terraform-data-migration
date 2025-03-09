provider "aws" {
  region = var.aws_region

  # 1. Add profile for multi-account support
  profile = var.aws_profile

  # 2. Add assume role for better security
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.assume_role_name}"
    session_name = "terraform-session-${var.environment}"
    duration     = "1h"
  }

  # 3. Add default tags for resource tagging
  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = var.project_name
    }
  }

  # 4. Add version constraint (optional)
  # version = "~> 5.0"
}