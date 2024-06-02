data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.keypair.key_name
  subnet_id                   = aws_subnet.subnet1.id
  vpc_security_group_ids      = ["${aws_security_group.owtf_sg.id}"]
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = "25"
    volume_type           = "gp2"
  }
  metadata_options {
    http_put_response_hop_limit = 2
    http_tokens = "required"
  }
  tags = {
    "Name" = "owtf_instance"
  }
  provisioner "local-exec" {
    command = "mkdir ssh_file; echo '${tls_private_key.ssh_key.private_key_openssh}' > ssh_file/${var.keypair_name}.pem; chmod 400 ssh_file/${var.keypair_name}.pem"
  }

  provisioner "local-exec" {
    command = <<EOT
    sleep 360;
    touch inventory.ini && echo "[all]" | tee -a inventory.ini;
    echo "${aws_instance.ec2.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.ansible_ssh_file} ansible_python_interpreter=${var.ansible_python_interpreter}" | tee -a inventory.ini;
    export ANSIBLE_HOST_KEY_CHECKING=False; 
    ansible-playbook -i inventory.ini playbook-kali.yml
    EOT
  }
}
