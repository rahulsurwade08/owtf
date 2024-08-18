resource "tls_private_key" "cert" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "sscert" {
  private_key_pem = tls_private_key.cert.private_key_pem
  subject {
    common_name  = "*.${var.region}.alb.amazonaws.com"
    organization = "OWASP-OWTF"
  }
  validity_period_hours = 8760
  is_ca_certificate     = false
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "self_signed_cert" {
  private_key       = tls_private_key.cert.private_key_pem
  certificate_body  = tls_self_signed_cert.sscert.cert_pem
  validation_method = "EMAIL"

  validation_option {
    domain_name       = "*.${var.region}.alb.amazonaws.com"
    validation_domain = var.email
  }
  tags = {
    Name = "owtf_self_signed_cert"
  }
}
