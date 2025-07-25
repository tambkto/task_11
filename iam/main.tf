resource "aws_iam_role" "service_role" {
  name = "serviceRoleUmar-tera"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "service_role_policy" {
  role = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}
resource "aws_iam_role_policy_attachment" "service_role_policy_2" {
  role = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
}
resource "aws_iam_role" "ec2_role" {
    name = "Ec2_beanstalk_Role_Umar-tera"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}
resource "aws_iam_role_policy_attachment" "ec2_role_policy_2" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}
resource "aws_iam_role_policy_attachment" "ec2_role_policy_3" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}
resource "aws_iam_role_policy_attachment" "ec2_role_policy_4" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "umar-beanstalk-ec2-instance-role-terra"
  role = aws_iam_role.ec2_role.name
}

#code build/pipeline roles
resource "aws_iam_role" "codepipeline-iam-role" {
  name = "umar-pipeline-beanstalk-role"
  assume_role_policy =  jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy" "codepipeline_role_policy" {
  name = "umar-codepipeline-service-role-policy"
  role = aws_iam_role.codepipeline-iam-role.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
  "Sid": "PassAnyRole",
  "Effect": "Allow",
  "Action": "iam:PassRole",
  "Resource": "*"
},

      
     {
    "Effect": "Allow",
    "Action": [
        "elasticbeanstalk:*",
        "s3:*",
        "cloudformation:*",
         "ec2:*",
        "elasticloadbalancing:*",
        "autoscaling:*",
        "cloudwatch:*",
    ],
    "Resource": "*"
     },

      {
        "Sid": "Statement5",
        "Effect": "Allow",
        "Action": [
          "codestar-connections:UseConnection"
        ],
        "Resource": "arn:aws:codeconnections:us-east-2:504649076991:connection/d78fdefc-5f9a-4c95-86da-9f9cdee3f352"
      },
      {
        "Sid": "Statement6",
        "Effect": "Allow",
        "Action": "codedeploy:*",
        "Resource": "*"
      },
      {
        "Sid": "Statement7",
        "Effect": "Allow",
        "Action": [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ],
        "Resource": "*"
      },
    ]
  })
}
#importing codepibuild role from AWS Console
resource "aws_iam_role" "codebuild-iam-role" {
  name = "umar-codebuild-service-role-2"
  assume_role_policy =  jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy" "codestar_connection_policy" {
  name = "codebuild-all-policies"
  role = aws_iam_role.codebuild-iam-role.id
  policy = jsonencode({
    
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Action": "ecr:*",
      "Resource": "*"
    },
    {
      "Sid": "Statement2",
      "Effect": "Allow",
      "Action": "codestar-connections:*",
      "Resource": "*"
    },
    {
      "Sid": "Statement3",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    },
    {
      "Sid": "Statement4",
      "Effect": "Allow",
      "Action": "codebuild:*",
      "Resource": "*"
    },
    {
      "Sid": "Statement5",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
      {
    "Effect": "Allow",
    "Action": [
        "elasticbeanstalk:*",
        "s3:*",
        "cloudformation:*",
         "ec2:*",
        "elasticloadbalancing:*",
        "autoscaling:*",
        
    ],
    "Resource": "*"
     },

  ]

  })
}

resource "aws_iam_role" "codedeploy-iam-role" {
  name = "umar-codedeploy-beanstalk-terra-task_11"
  assume_role_policy =  jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy" "codedeploy_iam_role_policy" {
  name = "umar-task11-codedeploy-beanstalk-policy"
  role = aws_iam_role.codedeploy-iam-role.name
   policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
    "Effect": "Allow",
    "Action": [
        "elasticbeanstalk:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "autoscaling:*",
        "cloudwatch:*",
        "s3:*",
        "cloudformation:*",
    ],
    "Resource": "*"
},
  ]
})
}