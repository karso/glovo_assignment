## --------------------------------
## Certifiacte
## --------------------------------

resource "aws_iam_server_certificate" "sslglovo-cert" {
  name_prefix      = "glovoapp-cert"
  certificate_body = "${file("glovo-cert.pem")}"
  private_key      = "${file("glovo-key.pem")}"

  lifecycle {
    create_before_destroy = true
  }
}
