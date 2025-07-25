terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "umar-elasticbeanstalk-terra-s3-bucket"
}
resource "aws_s3_object" "app_code" { //we upload the object to s3 bucket via this resource tag
  bucket = "umar-elasticbeanstalk-terra-s3-bucket"
  key = "appCode"
  source = "node-js-app.zip"
}
resource "aws_elastic_beanstalk_application" "application" {
  name = "umar-application-terra"
  appversion_lifecycle {
    service_role = var.service_role_arn
    max_count = 10
    delete_source_from_s3 = true
  }
}
resource "aws_elastic_beanstalk_application_version" "app_version" {
  name = "v1"
  application = aws_elastic_beanstalk_application.application.name
  bucket = aws_s3_bucket.s3_bucket.bucket
  key = aws_s3_object.app_code.key
}
resource "aws_elastic_beanstalk_environment" "environment" {
  name = "umar-application-enviornment-terra"
  application = aws_elastic_beanstalk_application.application.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.6.0 running Node.js 22"
  version_label = aws_elastic_beanstalk_application_version.app_version.name
  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = var.vpc_id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = join(",", var.private_subnet)//launching the ec2 resources in private subnet of vpc
  }
  setting {
    namespace  = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = join(",", var.public_subnet)
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "DisableDefaultEC2SecurityGroup"
    value = false
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = var.instance_profile
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = var.instance_type
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
}