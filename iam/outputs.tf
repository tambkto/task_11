output "service_role_arn" {
  value = aws_iam_role.service_role.arn
}
output "instance_role_name" {
  value = aws_iam_instance_profile.instance_profile.name
}
output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline-iam-role.arn
}
output "codebuild_iamrole_arn" {
  value = aws_iam_role.codebuild-iam-role.arn
}
output "codestar_connection_policy" {
  value = aws_iam_role_policy.codestar_connection_policy.name
}