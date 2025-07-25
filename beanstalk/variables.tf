variable "service_role_arn" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "private_subnet" {
  type = list(string)
}
variable "public_subnet" {
  type = list(string)
}
variable "instance_profile" {
  type = string
}
variable "instance_type" {
  type = string
}