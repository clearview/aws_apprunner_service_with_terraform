locals {
  api_port                   = 3000
  api_domain                 = "api.mydomain.team"
  api_git_repo               = "my/my_api"
  api_development_git_branch = "dev"
  api_ecr_image_development  = "${aws_ecr_repository.my_api_ecr.repository_url}:dev"
}
resource "aws_apprunner_service" "my_api" {

  depends_on = [
    aws_ecr_repository.my_api_ecr,
    aws_iam_role.my_app_runner_roles,
    aws_apprunner_vpc_connector.my_vpc_connector
  ]

  service_name = "my_api"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.my_app_runner_roles.arn
    }

    image_repository {
      image_identifier      = local.api_ecr_image_development
      image_repository_type = "ECR"
      image_configuration {
        port = 3000
        runtime_environment_variables = {
          # Server Port
          PORT = "3000"
          #
          NODE_ENV       = "development"
          LOG_LEVEL      = "debug"
          PORT           = local.api_port
          CONTAINER_PORT = local.api_port
          HOST_PORT      = local.api_port
        }
        runtime_environment_secrets = {
        }
      }
    }
    auto_deployments_enabled = true
  }


  health_check_configuration {
    path                = "/api/healthcheck"
    healthy_threshold   = 1
    interval            = 5
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 20
  }

  instance_configuration {
    cpu    = "2048"
    memory = "4096"
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.my_vpc_connector.arn
    }
  }

  tags = {
    Name = "my-my_api-apprunner-service"
  }
}

output "my_api_apprunner_my_api_service_url" {
  value       = aws_apprunner_service.my_api.service_url
  description = ""
}
