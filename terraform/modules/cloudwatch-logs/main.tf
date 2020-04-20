
variable "log-groups" {
  type = list(string)
  default = ["/var/log/messages",
    "/var/log/httpd/access_log",
    "/var/log/httpd/error_log",
    "/var/log/httpd/ssl_access_log",
    "/var/log/httpd/ssl_error_log",
    "/var/log/httpd/ssl_request_log",
    "/var/log/secure",
    "/var/log/yum.log",
    "/var/log/cron",
  ]
}
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  count = length(var.log-groups)

  name              = var.log-groups[count.index]
  retention_in_days = var.retention_in_days
}
