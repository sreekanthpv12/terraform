terraform {

  backend "s3" {
  bucket = "my-terraform-state-bucket320132"
  key    = "terraform.tfstate"
  region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}


# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "MyVPC"
  }
}


# Define the security group resource
resource "aws_security_group" "public_sg" {
  name        = "public-security-group"
  description = "Security group for public instance"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private-security-group"
  description = "Security group for private instance"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "private-sg"
  }
}


#Create a public subnet
resource "aws_subnet" "PublicSubnet"{
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-west-2a"
    cidr_block = var.public_subnet_cidr_block
    map_public_ip_on_launch = true
}

 # create a private subnet
resource "aws_subnet" "PrivSubnet"{
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.private_subnet_cidr_block
    map_public_ip_on_launch = false
    

}


 # create IGW
resource "aws_internet_gateway" "myIgw"{
    vpc_id = aws_vpc.myvpc.id
}

 # route Tables for public subnet
resource "aws_route_table" "PublicRT"{
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIgw.id
    }
}
 

 # route table association public subnet 
resource "aws_route_table_association" "PublicRTAssociation"{
    subnet_id = aws_subnet.PublicSubnet.id
    route_table_id = aws_route_table.PublicRT.id
}

# Creating NAT

#NAT need elastic ip so create elastic ip

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "my_nat_gateway" {
  # elastic ip allocation id
  subnet_id = aws_subnet.PublicSubnet.id
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Name = "my_nat_gateway"
  }
}

# Creating public instance
resource "aws_instance" "public" {
  ami                    = "ami-03f65b8614a860c29"
  instance_type          = "t2.micro"
  key_name               = "pinkkey13"
  subnet_id              = aws_subnet.PublicSubnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "public"
  }
}

# Creating private instance
resource "aws_instance" "private" {
  ami                    = "ami-03f65b8614a860c29"
  instance_type          = "t2.micro"
  key_name               = "pinkkey13"
  subnet_id              = aws_subnet.PrivSubnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "private"
  }
}


# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-state-bucket320132"
  acl    = "private"

  tags = {
    Name = "My Terraform Bucket"
  }
}




