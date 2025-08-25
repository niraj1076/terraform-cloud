terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  access_key = var.myaccess-key
  secret_key = var.my-secret
  region = "ap-south-1"
}

resource "aws_instance" "myblock" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.micro"
    key_name   = "my-terraform-key"
    tags = {
      Name = "my-instance"
    }
    vpc_security_group_ids = [ aws_security_group.security-block.id ]
}

resource "aws_security_group" "security-block" {
  name = "my-tera-sg"

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
}

# Generate an RSA private key
resource "tls_private_key" "example_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create an AWS EC2 Key Pair using the generated public key
resource "aws_key_pair" "example_key_pair" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.example_key.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "example_private_key" {
  content        = tls_private_key.example_key.private_key_pem
  filename       = "my-terraform-key.pem"
  file_permission = "0400"
}


