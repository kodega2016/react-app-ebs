variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

#### This is the configuration for the AWS Elastic Beanstalk application ####

variable "application_name" {
  description = "The name of the Elastic Beanstalk application"
  type        = string
  default     = "react-app"
}

variable "environment_name" {
  description = "The name of the Elastic Beanstalk environment"
  type        = string
  default     = "react-app-env"
}

variable "solution_stack_name" {
  description = "The solution stack name for the Elastic Beanstalk environment"
  type        = string
  default     = "64bit Amazon Linux 2023 v4.6.0 running Docker"
}

variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to use for the Elastic Beanstalk environment"
}

variable "min_size" {
  type        = number
  description = "The minimum number of instances in the Auto Scaling group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "The maximum number of instances in the Auto Scaling group"
  default     = 4
}
