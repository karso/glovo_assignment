## --------------------------------
## ELB
## --------------------------------
resource "aws_elb" "glovoweb-elb" {
  name = "elb-glovostack"
  subnets         = ["${module.vpc.public_subnets}"]
  security_groups = ["${aws_security_group.elbsg.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.sslglovo-cert.arn}"
}

  health_check {
  healthy_threshold = 2
  unhealthy_threshold = 2
  timeout = 3
  target = "HTTP:80/"
  interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "glovoweb-elb"
  }
}
