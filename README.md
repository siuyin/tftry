# Terraform Experiments

## Authenticating with Cloud Providers

AWS: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration

Google: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials

## Local Provider

https://registry.terraform.io/providers/hashicorp/local/latest/docs

The local provider provides a `direxists` function.

Resources and Data Sources `local_file` and `local_sensitive_file`

## Folder index
- awssecret: Using secrets with AWS.
- aws: Creating a compute instance within a custom VPC and postgres installation.
- chlab: Lab illustrating modules and use with Google compute and storage.
- func: Google cloud run functions.
- gke: Google Kubernetes Engine.
- gvm: Google compute instance with firewall config and postgres installation.
- local: Terraform `local` provider.
- mkbkt: Making Google cloud storage buckets.
- run: Google cloud run example with service accounts and IAM permissions.
