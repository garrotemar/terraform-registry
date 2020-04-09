module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = "my-vpc"
  cidr = "192.168.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  public_subnets  = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "testing"
  }
}

module "webserver" {
  # source = "github.com/garrotemar/terraform-module-ec2-with-eip?ref=v1.0.2"
  source  = "garrotemar/ec2-with-eip/module"
  version = "1.0.2"

  ami = "ami-0fc20dd1da406780b"
  instance_type = "t2.micro"
  key_name = "microserver"
  vpc_id = "${module.vpc.vpc_id}"
  project_name = "webserver"
  environment = "testing"
  subnet_id = "${element(module.vpc.public_subnets,0)}"
}
