variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}
variable "db_pass_dev" {
  description = "db_pass_dev"
}
variable "slack_webhook" {
  description = "slack_webhook"
}


# Regions
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "region_northern_virginia" {
  description = "AWS northern_virginia region"
  default     = "us-east-1"
}
