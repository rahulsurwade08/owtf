data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ubuntu_ami_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["${var.virt_type}"]
  }

  owners = ["${var.canonical_account}"]
}

resource "aws_security_group" "owtf_sg" {
  name   = "owtf_sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.owtf_admin_port
    to_port     = var.owtf_admin_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }
  ingress {
    from_port   = var.owtf_ui_port
    to_port     = var.owtf_ui_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }
  ingress {
    from_port   = var.owtf_proxy_port
    to_port     = var.owtf_proxy_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  key_name                    = aws_key_pair.keypair.key_name
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = ["${aws_security_group.owtf_sg.id}"]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }

  metadata_options {
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  tags = {
    "Name" = "owtf_instance"
  }

  user_data  = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo snap install amazon-ssm-agent --classic
              sudo snap start amazon-ssm-agent
              sudo apt install awscli -y
              sudo apt install software-properties-common -y
              sudo add-apt-repository --yes --update ppa:ansible/ansible
              sudo apt install ansible -y
              EOF
  depends_on = [aws_lb.alb, aws_vpc.vpc, aws_instance.nat_instance, null_resource.wait_for_nat]
}

resource "null_resource" "wait_for_ec2" {
  provisioner "local-exec" {
    command = <<EOT
    sleep 360
    EOT
  }
  depends_on = [aws_instance.ec2]
}