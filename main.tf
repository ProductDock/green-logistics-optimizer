# main.tf in the project root

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1" # Enforcing the EU Sovereign Boundary
}

variable "aws_account_id" {
  type      = string
  sensitive = true
}

# 1. Include the API Gateway Folder
module "api" {
  source = "./aws/api"
  
  # Pass the Lambda's Invoke ARN to the API integration
  lambda_uri = module.green_logistics_lambda.invoke_arn 
}

# 2. Include the Lambda Folder
module "green_logistics_lambda" {
  source           = "./aws/lambda/green-logistics-optimizer-lambda-edelic"
  aws_account_id   = var.aws_account_id
  
  # Pass API details to the Lambda for permissions
  api_id           = module.api.api_id
  root_resource_id = module.api.root_resource_id
}

# 3. Output the final endpoint for Postman testing
output "final_api_endpoint" {
  value       = module.api.invoke_url
  description = "The public URL to trigger the Green Logistics Optimizer"
}