data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ubuntu_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.canonical_account_id]
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  key_name                    = aws_key_pair.keypair.key_name
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = ["${aws_security_group.ec2_sg.id}"]
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
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y amazon-ssm-agent
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              EOF
  tags = {
    "Name" = "owtf_instance"
  }
}
resource "null_resource" "deploy_ssm" {
  provisioner "local-exec" {
    command = <<EOT
    sleep 600;
    aws ssm send-command \
      --document-name "RunAnsiblePlaybook" \
      --targets "Key=instanceids,Values=${aws_instance.ec2.id}" \
      --comment "Running Ansible playbook" \
      --region "us-west-2"
    EOT
  }
}
