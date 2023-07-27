module "my_aws_vpc" {
  source = "./.."

  aws_region            = "us-east-1"
  name_prefix           = "aws_vpc_module_test"
  vpc_cidr_block        = "10.0.0.0/16"
  max_az_count          = 2
  max_nat_gateway_count = 1

  vpc_tags = {
    Foo = "vpc"
  }
  internet_gateway_tags = {
    Foo = "internet_gateway"
  }
  public_subnet_tags = {
    Foo = "public_subnet"
  }
  public_route_table_tags = {
    Foo = "public_route_table"
  }
  private_subnet_tags = {
    Foo = "private_subnet"
  }
  nat_eip_tags = {
    Foo = "nat_eip"
  }
  nat_gateway_tags = {
    Foo = "nat_gateway"
  }
  private_route_table_tags = {
    Foo = "private_route_table"
  }
}
