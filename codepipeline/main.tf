terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
resource "aws_s3_bucket" "umar-codepipeline-bucket" {
  bucket = "umar-codepipeline-bucket"
  tags = {
    name = "umar bucket"
  }
}
resource "aws_codepipeline" "codepipeline" {
  name     = "umar-task8-pipeline"
  role_arn = var.codepipeline_role_arn // has to add role in IAM module.
  pipeline_type = "V2"
  artifact_store {
    location = aws_s3_bucket.umar-codepipeline-bucket.bucket
    type     = "S3" 
  }
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.github-connection.arn
        FullRepositoryId = "tambkto/task_11"
        BranchName       = "main"
      }
    }
  }
  stage {
    name = "Build"
      
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "umar-codebuild-project"
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName = var.beanstalk-application-name
        EnvironmentName = var.beanstalk-envioronent-name
      }
    }
  }
}
data "aws_codestarconnections_connection" "github-connection" {
  name = "umar-connection-github"
}
resource "aws_codebuild_project" "codebuild-project" {
  name         = "umar-codebuild-project"
  service_role = var.codebuild_iamrole_arn        //attach codebuild service role here from IAM module.

  artifacts {
    type = "CODEPIPELINE"
  }
  depends_on = [
  var.connection-policy
]


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.log-group.name
      stream_name = "build-logs"
      status = "ENABLED"
    }
  }

  source {
    type     = "CODEPIPELINE"
  }
}
resource "aws_cloudwatch_log_group" "log-group" {
  name = "umar-task-11-log-group"
}