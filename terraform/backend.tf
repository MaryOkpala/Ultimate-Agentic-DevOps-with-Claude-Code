# Backend configuration for storing Terraform state remotely.
#
# First-time setup:
#   1. Run `terraform init` with this block commented out (as it is below).
#      This uses local state so Terraform can create the S3 bucket (and any
#      other resources) that the remote backend depends on.
#   2. Run `terraform apply` to create your infrastructure, including a
#      dedicated S3 bucket for storing Terraform state (create one manually
#      or via a separate bootstrap configuration if you don't have one yet).
#   3. Uncomment the backend block below and fill in the bucket name, key,
#      and region for your state bucket.
#   4. Run `terraform init -migrate-state` to migrate local state into the
#      remote S3 backend.
#
# terraform {
#   backend "s3" {
#     bucket  = "your-terraform-state-bucket-name"
#     key     = "portfolio-site/terraform.tfstate"
#     region  = "ap-south-1"
#     encrypt = true
#   }
# }
