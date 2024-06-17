resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "owtf_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "owtf_igw"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "owtf_subnet1"
  }
}

resource "aws_security_group" "owtf_sg" {
  name   = "owtf_sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8008
    to_port     = 8008
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8009
    to_port     = 8009
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8010
    to_port     = 8010
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

