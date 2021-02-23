terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
   }
  }
}

provider "aws" {
  region     = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
}


resource "aws_instance" "ec2" {
    ami = var.ami
    instance_type = var.type
    key_name = var.key_name
    subnet_id = aws_subnet.Public_subnet_A.id
    associate_public_ip_address = true
    security_groups = ["${aws_security_group.projectsg.id}"]
    tags = {
        Name = "A"
}
}

resource "aws_vpc" "r3_vpc" {
    cidr_block = var.cidr

    tags = {
        Name = "r3_vpc"
    }   
}

resource "aws_subnet" "Public_subnet_A" {
    cidr_block = var.public_cidr_A
    vpc_id = aws_vpc.r3_vpc.id
    map_public_ip_on_launch = true

    tags = {
        Name = "Pubnet_subnet_A"
    }
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.r3_vpc.id

  tags = {
    Name = "VPC Internet Gateway"
  }

}

resource "aws_route_table" "vpc_rt" {
  vpc_id = aws_vpc.r3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "Route Table for VPC"
  }
}

resource "aws_route_table_association" "pub_subA_rta" {
  subnet_id      = aws_subnet.Public_subnet_A.id
  route_table_id = aws_route_table.vpc_rt.id
}

resource "aws_security_group" "projectsg" {
    name = "projectsg"
    description = "Allow inbound traffic"
    vpc_id = aws_vpc.r3_vpc.id

    dynamic "ingress" {
        iterator = port
        for_each = var.ingress_ports
        content {
            from_port = port.value
            protocol = "tcp"
            to_port = port.value
            cidr_blocks = var.open-internet  
        }
        
    }

    egress {
        from_port = var.outbound-port
        protocol = "-1"
        to_port = var.outbound-port
        cidr_blocks = var.open-internet
    }

    tags = {
        Name = "projectsg"
    }  
}
