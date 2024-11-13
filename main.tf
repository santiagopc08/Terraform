provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Subnet
resource "aws_subnet" "terraform_public_subnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

# Internet Gateway
resource "aws_internet_gateway" "terraform_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
}

# Route Table
resource "aws_route_table" "terraform_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }
}

# Route Table Association
resource "aws_route_table_association" "terraform_route_association" {
  subnet_id      = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.terraform_route_table.id
}

# Security Group
resource "aws_security_group" "terraform_security_group" {
  vpc_id = aws_vpc.terraform_vpc.id
  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "terraform_ec2" {
  ami           = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.terraform_public_subnet.id
  vpc_security_group_ids = [aws_security_group.terraform_security_group.id]

  key_name = "terraform"

  tags = {
    Name = "TerraformEC2"
  }
}
