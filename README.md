# Terraform Module: Amazon VPC

## Static Testing

```shell
terraform fmt -check -recursive .
terraform init -backend=false
terraform validate .
```

## Dynamic Testing

Create the `test/terraform_backend.tf` file. Example:

```tf
terraform {
  backend "s3" {
    region = "BUCKET_REGION"
    bucket = "BUCKET_NAME"
    key    = "test/aws_vpc_module_test.tfstate"
  }
}
```

```shell
cd test
terraform init
terraform validate .
terraform plan -out plan_create
terraform apply plan_create
terraform plan -destroy -out plan_destroy
terraform apply plan_destroy
```

## GitHub Actions and GitLab Pipelines Configuration

- TERRAFORM_BACKEND_S3_REGION
- TERRAFORM_BACKEND_S3_BUCKET
