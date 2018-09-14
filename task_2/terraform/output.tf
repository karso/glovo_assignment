## --------------------------------
## Output
## --------------------------------

output "elb-dns" {
  value = "${aws_elb.glovoweb-elb.dns_name}"
}

