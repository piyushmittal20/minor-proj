resource "aws_codedeploy_app" "codedeploy_application" {
  compute_platform = "Server"
  name             = "node_react_application"
}

resource "aws_codedeploy_deployment_config" "foo" {
  deployment_config_name = "test-deployment-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 1
  }
}

resource "aws_codedeploy_deployment_group" "codedeploy_group" {
  app_name               = aws_codedeploy_app.codedeploy_application.name
  deployment_group_name  = "react-app-deployment"
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  deployment_config_name = aws_codedeploy_deployment_config.foo.id

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "application-server"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
