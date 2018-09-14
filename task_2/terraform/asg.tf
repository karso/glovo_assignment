## --------------------------------
## LC 
## --------------------------------

resource "aws_launch_configuration" "appnode-lc" {
  image_id= "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.appnodesg.id}"]
  key_name = "${var.aws_key_name}"
  user_data = "${data.template_file.app_user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}


## --------------------------------
## ASG 
## --------------------------------

resource "aws_autoscaling_group" "app-asg" {
  launch_configuration = "${aws_launch_configuration.appnode-lc.name}"
  min_size = "${var.min_cluster_size}"
  max_size = "${var.max_cluster_size}"
  desired_capacity = "${var.des_cluster_size}"
  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  vpc_zone_identifier = ["${module.vpc.private_subnets}"]
  metrics_granularity="1Minute"
  load_balancers= ["${aws_elb.glovoweb-elb.id}"]
  health_check_type="ELB"
  tag {
    key = "Name"
    value = "glovo-app-node"
    propagate_at_launch = true
  }
}

## --------------------------------
## ASG Policy - Up
## --------------------------------

resource "aws_autoscaling_policy" "nodescalepolicy-up" {
  name = "app-node-policy-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.app-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-up" {
  alarm_name = "cpu-alarm-hi"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.app-asg.name}"
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.nodescalepolicy-up.arn}"]
}

## --------------------------------
## ASG Policy - Down
## --------------------------------
#
resource "aws_autoscaling_policy" "nodescalepolicy-down" {
  name = "app-node-policy-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.app-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
  alarm_name = "cpu-alarm-lo"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.app-asg.name}"
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.nodescalepolicy-down.arn}"]
}

## --------------------------------
## User Data
## --------------------------------
data "template_file" "app_user_data" {
  template = "${file("${path.module}/templates/app_user_data.tpl")}"

  vars {
    magic_header = "${var.secret_header_value}"
  }
}

