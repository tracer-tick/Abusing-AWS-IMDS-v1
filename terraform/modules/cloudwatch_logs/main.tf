resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  count = length(var.cloudwatch_log_group_names)

  name              = var.cloudwatch_log_group_names[count.index]
  retention_in_days = var.retention_in_days
}
