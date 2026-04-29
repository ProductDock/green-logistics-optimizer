provider "aws" {
  region = "eu-central-1" # Enforce EU boundary
}

variable "aws_account_id" {
  type      = string
  sensitive = true
}

# This data source allows sub-files to reference your Account ID automatically
data "aws_caller_identity" "current" {}