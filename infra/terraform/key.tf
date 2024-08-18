resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "owtf_keypair"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
