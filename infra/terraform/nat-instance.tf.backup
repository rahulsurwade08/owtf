data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["${var.amazon_account}"]

  filter {
    name   = "name"
    values = ["${var.al2_ami_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["${var.virt_type}"]
  }
}

resource "aws_instance" "nat_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.keypair.key_name
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]
  source_dest_check           = false
  tags = {
    Name = "nat_instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              LOGFILE=/var/log/nat_instance_setup.log

              exec > >(tee -a $LOGFILE) 2>&1

              echo "Updating system packages..."
              if ! sudo yum update -y; then
                echo "Error: Failed to update system packages" >&2
                exit 1
              fi

              echo "Installing iptables-services..."
              if ! sudo yum install -y iptables-services; then
                echo "Error: Failed to install iptables-services" >&2
                exit 1
              fi

              echo "Enabling iptables service..."
              if ! sudo systemctl enable iptables; then
                echo "Error: Failed to enable iptables service" >&2
                exit 1
              fi

              echo "Starting iptables service..."
              if ! sudo systemctl start iptables; then
                echo "Error: Failed to start iptables service" >&2
                exit 1
              fi

              echo "Enabling IP forwarding..."
              if ! sudo sysctl -w net.ipv4.ip_forward=1; then
                echo "Error: Failed to enable IP forwarding" >&2
                exit 1
              fi

              echo "Setting up iptables MASQUERADE rule..."
              if ! sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; then
                echo "Error: Failed to set iptables MASQUERADE rule" >&2
                exit 1
              fi

              echo "Flushing FORWARD rules..."
              if ! sudo /sbin/iptables -F FORWARD; then
                echo "Error: Failed to flush FORWARD rules" >&2
                exit 1
              fi

              echo "Saving iptables rules..."
              if ! sudo service iptables save; then
                echo "Error: Failed to save iptables rules" >&2
                exit 1
              fi

              echo "NAT instance setup completed successfully."
              EOF

  depends_on = [aws_vpc.vpc]
}

# Create a security group for the NAT Instance
resource "aws_security_group" "nat_sg" {
  name   = "nat_sg"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name = "nat_sg"
  }
}

resource "null_resource" "wait_for_nat" {
  provisioner "local-exec" {
    command = <<EOT
    sleep 360
    EOT
  }
  depends_on = [aws_instance.nat_instance]
}
