module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "ec2-security-group"
  description = "Security group for EC2"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    "Role" = "node-app"
    "Type" = "security-group"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "application-server"

  ami                         = "ami-074dc0a6f6c764218"
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.ec2_security_group.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = <<EOL
        #! /bin/bash
        sudo yum update
        sudo yum install -y ruby
        sudo yum install wget
        wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
        chmod +x ./install
        sudo ./install auto
        sudo service codedeploy-agent start 
EOL

  tags = {
    "Terraform" = "true"
    "Type"      = "EC2"
  }
}
