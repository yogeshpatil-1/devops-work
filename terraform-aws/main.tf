locals {
  tags = {
    Project = var.project
    ManagedBy = "Terraform"
  }
}

# VPC
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.tags, { Name = "${var.project}-vpc" })
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"
  tags = merge(local.tags, { Name = "${var.project}-public-subnet" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "${var.project}-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.tags, { Name = "${var.project}-public-rt" })
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Key pair
resource "aws_key_pair" "this" {
  key_name   = "${var.project}-key"
  public_key = file(var.public_key_path)
}

# Security group
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-sg"
  vpc_id      = aws_vpc.this.id
  description = "Allow SSH and HTTP"
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

# EC2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] # Amazon
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name
  user_data                   = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable nginx
    echo "Hello from Terraform!" > /usr/share/nginx/html/index.html
    systemctl start nginx
  EOF
  tags = merge(local.tags, { Name = "${var.project}-ec2" })
}

# S3 bucket
resource "aws_s3_bucket" "this" {
  bucket = "${var.project}-bucket-${random_id.rand.hex}"
  force_destroy = true
  tags = local.tags
}

resource "random_id" "rand" {
  byte_length = 4
}
