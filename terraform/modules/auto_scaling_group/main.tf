resource "aws_autoscaling_group" "aws_autoscaling_group" {
  desired_capacity      = var.aws_autoscaling_group_desired_capacity
  health_check_type     = "ELB"
  launch_configuration  = aws_launch_configuration.aws_launch_configuration.name
  max_size              = var.aws_autoscaling_group_max_size
  min_size              = var.aws_autoscaling_group_min_size
  name                  = var.aws_autoscaling_group_name
  target_group_arns     = var.alb_target_group_arns
  vpc_zone_identifier   = var.public_subnet_ids
  wait_for_elb_capacity = 1

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "aws_launch_configuration" {
  iam_instance_profile = aws_iam_instance_profile.aws_iam_instance_profile.arn
  image_id             = data.aws_ami.amazon_linux_2.id
  instance_type        = var.instance_type
  name                 = var.aws_launch_configuration_name
  security_groups      = [var.security_group_id]
  user_data            = file("../misc/user_data.sh")
}

resource "aws_iam_role" "aws_iam_role" {
  assume_role_policy = var.assume_role_policy
  name               = var.aws_iam_role_name
}

resource "aws_iam_policy" "aws_iam_policy_1" {
  name   = var.aws_iam_policy_1_name
  policy = var.aws_iam_policy_1_json
}

resource "aws_iam_policy" "aws_iam_policy_2" {
  name   = var.aws_iam_policy_2_name
  policy = var.aws_iam_policy_2_json
}

resource "aws_iam_instance_profile" "aws_iam_instance_profile" {
  name = var.aws_iam_instance_profile_name
  role = aws_iam_role.aws_iam_role.name
}

resource "aws_iam_role_policy_attachment" "aws_iam_role_policy_attachment_1" {
  policy_arn = aws_iam_policy.aws_iam_policy_1.arn
  role       = aws_iam_role.aws_iam_role.name
}
resource "aws_iam_role_policy_attachment" "aws_iam_role_policy_attachment_2" {
  policy_arn = aws_iam_policy.aws_iam_policy_2.arn
  role       = aws_iam_role.aws_iam_role.name
}