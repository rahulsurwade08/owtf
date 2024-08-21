variable "region" {
  default = "us-west-2"
}

variable "owtf_ui_port" {
  default = "8009"
}

variable "owtf_admin_port" {
  default = "8008"
}

variable "owtf_proxy_port" {
  default = "8010"
}

variable "ubuntu_ami_name" {
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "al2_ami_name" {
  default = "amzn2-ami-hvm-*-x86_64-gp2"
}

variable "virt_type" {
  default = "hvm"
}

variable "canonical_account" {
  default = "099720109477"
}

variable "amazon_account" {
  default = "137112412989"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "volume_size" {
  default = "25"
}

variable "volume_type" {
  default = "gp2"
}

variable "policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

variable "cidr_block" {
  default = "0.0.0.0/0"
}

variable "vpc_cidr_block" {
  default = "10.1.0.0/16"
}

variable "public_subnet1_cidr" {
  default = "10.1.1.0/24"
}

variable "public_subnet2_cidr" {
  default = "10.1.2.0/24"
}

variable "private_subnet_cidr" {
  default = "10.1.3.0/24"
}

variable "playbookurl" {
  default = "https://raw.githubusercontent.com/owtf/owtf/develop/infra/terraform/playbook-ubuntu.yaml"
}

variable "timeoutseconds" {
  default = 3600
}

variable "check" {
  default = "False"
}