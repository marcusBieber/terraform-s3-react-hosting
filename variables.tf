variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "eu-central-1"
}

variable "site_name" {
  default     = "www.marcus-bieber.de"
  description = "name of the site"
}