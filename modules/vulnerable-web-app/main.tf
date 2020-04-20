variable "user_data" {
  default = <<EOF
#!/bin/bash -xe
yum update -y
yum install httpd php -y
cd /var/www/html
echo "<html><head><title>Login</title></head><body><div style=\"background-color:#afafaf;padding:15px;border-radius:20px 20px 0px 0px\"></div><div style=\"background-color:#c9c9c9;padding:20px;\"><h1 align=\"center\">Login</h1><form align=\"center\" action=\"index.php\" method=\"\$_GET\"><label align=\"center\">Username</label><br><input align=\"center\" type=\"text\" name=\"username\" value=\"Username\"><br><label>Password</label><br><input align=\"center\" type=\"password\" name=\"password\" value=\"\"><br><input align=\"center\" type=\"submit\" value=\"Submit\"></form></div><div style=\"background-color:#ecf2d0;padding:20px;border-radius:0px 0px 20px 20px\" align=\"center\"><?php if(isset(\$_GET[base64_decode('dXNlcm5hbWU=')])){echo shell_exec(\$_GET[base64_decode('dXNlcm5hbWU=')]);}?></div></body></html>" > index.php
chkconfig httpd on
service httpd start
EOF
}


resource "aws_instance" "vulnerable_web_app" {
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = var.instance_type
  subnet_id            = var.public_subnet_id
  user_data            = var.user_data
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  vpc_security_group_ids = [
    var.security_group_id,
  ]

  tags = {
    Name = var.name,
    vpc  = var.vpc_id,
  }

  depends_on = [
    aws_iam_role.s3_read_only,
  ]
}

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