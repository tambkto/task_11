output "app-name" {
  value = aws_elastic_beanstalk_application.application.name
}
output "env-name" {
  value = aws_elastic_beanstalk_environment.environment.name
}