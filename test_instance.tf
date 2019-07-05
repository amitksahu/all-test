resource "aws_launch_configuration" "test" {
  name_prefix = "test-"
  image_id = "${data.aws_ami.amazon_linux.id}"
  instance_type = "${var.bastion_instance_type}"
  enable_monitoring = false
  security_groups = ["${aws_security_group.test.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "test" {
  max_size = 1
  min_size = 0
  desired_capacity = 1
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.test.name}"
  vpc_zone_identifier = ["${aws_subnet.private.*.id}"]
}


resource "aws_security_group" "test" {
  name_prefix = "private-sg"
  description = "SG for private"
  vpc_id = "${aws_vpc.main.id}"

}