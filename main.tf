# provider define
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  # access_key = "xxx"
  # secret_key = "yyy"
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_instance" "res-web" {
  ami           = "ami-0aeb7c931a5a61206"
  instance_type = "t2.micro"
  availability_zone = "us-east-2b"
  key_name = "terraform-demo-jyue-ohio"
  associate_public_ip_address = true

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo bash -c 'echo This is my first AWS web server > /var/www/html/index.html'
              EOF


  tags = {
    Name = "res-web-server-ohio"
  }
}

resource "aws_vpc" "res-main-vpc" {
  cidr_block       = "10.0.1.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "res-main-vpc"
  }
}

resource "aws_subnet" "res-subnet-02" {
  vpc_id     = aws_vpc.res-main-vpc.id
  cidr_block = "10.0.1.128/25"
  availability_zone = "us-east-2b"
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "res-subnet-02"
  }
}

resource "aws_internet_gateway" "res-igw" {
  vpc_id = aws_vpc.res-main-vpc.id

  tags = {
    Name = "res-igw-ue2"
  }
}


resource "aws_route_table" "res-rt" {
  vpc_id = aws_vpc.res-main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.res-igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.res-igw.id
  }

  tags = {
    Name = "res-routetable-ue2"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.res-subnet-02.id
  route_table_id = aws_route_table.res-rt.id
}


resource "aws_security_group" "allow_web_server_ports" {
  name        = "allow_web_server_ports"
  description = "Allow Web server inbound traffics"
  vpc_id      = aws_vpc.res-main-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["18.162.0.0/16"]
  }

    ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["18.162.0.0/16"]
  }

    ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["18.162.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_server_ports"
  }
}


resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.res-subnet-02.id
  private_ips     = ["10.0.1.200"]
  security_groups = [aws_security_group.allow_web_server_ports.id]
}


# resource "aws_eip" "one" {
#   vpc                       = true
#   network_interface         = aws_network_interface.web-server-nic.id
#   associate_with_private_ip = "10.0.1.200"
#   depends_on = [
#     aws_internet_gateway.res-igw, aws_network_interface.web-server-nic, aws_instance.res-web
#   ]
# }

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.res-web.id
#   allocation_id = aws_eip.one.id
# }