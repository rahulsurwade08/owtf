variable "region" {
  default = "us-west-2"
}

variable "server_url" {
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "email" {
  default = "rahulsurwade6970@gmail.com"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "ansible_ssh_file" {
  default = "ssh_file/owtf_keypair.pem"
}

variable "ansible_python_interpreter" {
  default = "/usr/bin/python3"
}

variable "keypair_name" {
  default = "owtf_keypair"
}

variable "ubuntu_ami_name" {
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "canonical_account_id" {
  default = "099720109477"
}
variable "volume_size" {
  default = 25
}

variable "volume_type" {
  default = "gp2"
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