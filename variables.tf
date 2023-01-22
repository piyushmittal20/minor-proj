variable "ec2_iam_policy_arn" {
  description = "The default in-built IAM policy required for the EC2"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"]
}

variable "codedeploy_iam_policy_arn" {
  description = "The default in-built IAM policy required for the codedeploy"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole",
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
}

variable "key_name" {
  type    = string
  default = "ec2-key"
}
