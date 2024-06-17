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