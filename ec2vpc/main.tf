terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
        }
    }
    
}
provider "aws" {
    region = "ap-south-1"
    profile = "saif"
}
resource "aws_vpc" "javaserver_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    tags = {
        Name = "javaserver_vpc"
    }
}
resource "aws_subnet" "javaserver_public_subnet" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.javaserver_vpc.id
    availability_zone = var.public_subnet_az
    map_public_ip_on_launch = true
    tags = {
        Name = "javaserver_public_subnet"
    }

}
resource "aws_subnet" "javaserver_private_subnet" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.javaserver_vpc.id
    availability_zone = var.private_subnet_az
    tags = {
        Name = "javaserver_private_subnet"
    }

}
resource "aws_internet_gateway" "javaserver_inet_gateway" {
    vpc_id = aws_vpc.javaserver_vpc.id
    tags = {
        Name = "javaserver_inet_gateway"
    }
}
resource "aws_route_table" "javaserver_inet_gateway_routetable" {
     vpc_id = aws_vpc.javaserver_vpc.id   
     route  {
         cidr_block = "0.0.0.0/0"
         gateway_id = aws_internet_gateway.javaserver_inet_gateway.id
    }
    tags = {
        Name = "javaserver_inet_gateway_routetable"
    }
}
resource "aws_route_table_association" "javaserver_inet_gateway_routetable_association" {
    subnet_id = aws_subnet.javaserver_public_subnet.id  
    route_table_id = aws_route_table.javaserver_inet_gateway_routetable.id  

}
resource "aws_key_pair" "javaserver_key_pair" {
    key_name = "javaserver_key"
    public_key = var.public_key
}

resource "aws_security_group" "javaserver_sg" {
     vpc_id = aws_vpc.javaserver_vpc.id   
     ingress {
     description = "TLS from VPC"
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    }
     egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "javaserver_sg"
    }
}

resource "aws_instance" "javaserver" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.javaserver_public_subnet.id  
    associate_public_ip_address = true
    key_name = aws_key_pair.javaserver_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.javaserver_sg.id]    
    tags = {
        Name = "javaserver"
    }
}