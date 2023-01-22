resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codedeploy.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "type" = "code_deploy_role"
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  count      = length(var.codedeploy_iam_policy_arn)
  policy_arn = var.codedeploy_iam_policy_arn[count.index]
}
