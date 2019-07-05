resource "aws_key_pair" "bastion" {
  key_name = "bastion-key"
  public_key = "${data.template_file.bastion_public_key.rendered}"
}

resource "aws_launch_configuration" "bastion" {

  name_prefix = "bastion-"
  image_id = "${data.aws_ami.amazon_linux.id}"
  instance_type = "${var.bastion_instance_type}"
  key_name = "${aws_key_pair.bastion.key_name}"
  associate_public_ip_address = true
  enable_monitoring = false
  security_groups = ["${aws_security_group.bastion.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name = "bastion-asg"
  max_size = 1
  min_size = 0
  desired_capacity = 1
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  vpc_zone_identifier = ["${aws_subnet.public.*.id}"]

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "bastion"
  }
}

resource "aws_security_group" "bastion" {
  name_prefix = "bastion sg"
  description = "SG for bastion"
  vpc_id = "${aws_vpc.main.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all_ssh" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion.id}"
  to_port = 22
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.bastion.id}"
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]

  ## "-1" is used for all protocol
}