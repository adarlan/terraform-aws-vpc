module "aws_vpc" {

  source = "./.."

  aws_region            = "us-east-1"
  name_prefix           = "aws_vpc_module_test"
  vpc_cidr_block        = "10.0.0.0/16"
  max_az_count          = 2
  max_nat_gateway_count = 1

  tags = {
    Environment = "Test"
    Project     = "Terraform AWS VPC Module Test"
  }

  vpc_tags = {
    vpc = "vpc"
  }
  internet_gateway_tags = {
    internet_gateway = "internet_gateway"
  }
  public_subnet_tags = {
    public_subnet = "public_subnet"
  }
  public_route_table_tags = {
    public_route_table = "public_route_table"
  }
  private_subnet_tags = {
    private_subnet = "private_subnet"
  }
  nat_eip_tags = {
    nat_eip = "nat_eip"
  }
  nat_gateway_tags = {
    nat_gateway = "nat_gateway"
  }
  private_route_table_tags = {
    private_route_table = "private_route_table"
  }
}
