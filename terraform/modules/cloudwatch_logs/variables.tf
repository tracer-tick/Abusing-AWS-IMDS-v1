variable "cloudwatch_log_group_names" {
  type = list(string)
  default = [
    "/var/log/cron",
    "/var/log/httpd/access_log",
    "/var/log/httpd/error_log",
    "/var/log/httpd/ssl_access_log",
    "/var/log/httpd/ssl_error_log",
    "/var/log/httpd/ssl_request_log",
    "/var/log/messages",
    "/var/log/secure",
    "/var/log/yum.log",
  ]
}
variable "retention_in_days" {
  type        = number
  description = "Log group retention in days"
}