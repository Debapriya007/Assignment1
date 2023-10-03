terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Initialize the AWS provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIATUNDYZUYWGIFQ5HX"
  secret_key = "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"
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
 vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

# Create an EC2 instance in the public subnet
resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "newkey"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
tags = {
    "Name"    = "Assignment_Instance"
    "purpose" = "Assignment"
  }
}

# Create a security group for the EC2 instance
resource "aws_security_group" "my_security_group" {
  name_prefix = "my_security_group_"
  description = "Security group for Assignment EC2 instance"

  # Inbound rule for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule for all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}                                
