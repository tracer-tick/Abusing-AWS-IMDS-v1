resource "aws_autoscaling_group" "asg" {
  name                  = "${var.name}-asg"
  desired_capacity      = 1
  max_size              = 1
  min_size              = 1
  health_check_type     = "ELB"
  wait_for_elb_capacity = 1
  vpc_zone_identifier   = var.public_subnet_ids
  target_group_arns     = [var.alb_tg_arn]
  enabled_metrics = ["GroupDesiredCapacity",
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

  launch_configuration = aws_launch_configuration.as_conf.name

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "as_conf" {
  name                 = "${var.name}-conf"
  image_id             = data.aws_ami.amazon-linux-2.id
  instance_type        = var.instance_type
  user_data            = file(".//modules//auto-scaling-group//user_data.sh")
  iam_instance_profile = aws_iam_instance_profile.instance_profile.arn
  security_groups      = [var.security_group_id]
}

# Instance Profile
resource "aws_iam_role" "s3_read_only" {
  name               = "s3_read_only"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "s3_read_only" {
  name        = "s3-read-only"
  description = "Allows all head, list, and get options for S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:Head*",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "assume_role"
  role = aws_iam_role.s3_read_only.name
}

resource "aws_iam_role_policy_attachment" "s3_read_only_attach" {
  role       = aws_iam_role.s3_read_only.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}