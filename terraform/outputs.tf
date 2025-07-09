output "ebs_application_name" {
  description = "The name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.this.name
}

output "ebs_environment_name" {
  description = "The name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.name
}

output "ebs_environment_url" {
  description = "The URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.endpoint_url
}

output "ebs_cname" {
  description = "The CNAME of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.cname
}

output "application_url" {
  description = "The complete URL to access the React application"
  value       = "http://${aws_elastic_beanstalk_environment.this.cname}"
}
