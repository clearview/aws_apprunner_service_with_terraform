locals {
  my_fe_port                   = 3001
  my_fe_domain                 = "frontend.my-domain.org"
  my_fe_apprunner_domain       = "members.development.my-domain.org"
  my_fe_ecr_image_development  = "${aws_ecr_repository.my_fe_ecr.repository_url}:dev"
  my_fe_git_repo               = "clearview/my-members-fe"
  my_fe_development_git_branch = "dev"
}

resource "aws_apprunner_service" "my_fe" {
  depends_on = [
    aws_ecr_repository.my_fe_ecr
  ]

  service_name = "my_fe"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.my_app_runner_roles.arn
    }

    image_repository {
      image_identifier      = local.my_fe_ecr_image_development
      image_repository_type = "ECR"
      image_configuration {
        port          = local.my_fe_port
        start_command = "yarn dev"
        runtime_environment_variables = {
          HOST           = "0.0.0.0"
          HOSTNAME       = "0.0.0.0"
          NITRO_HOST     = "0.0.0.0"
          ENV            = "development"
          NODE_ENV       = "development"
          PORT           = local.my_fe_port
          NITRO_PORT     = local.my_fe_port
          CONTAINER_PORT = local.my_fe_port
          HOST_PORT      = local.my_fe_port
          # API
          PROXY_TARGET      = "https://${local.api_domain}"
          NUXT_API_BASE_URL = "https://${local.api_domain}"
          # Nuxt
          NUXT_PUBLIC_DEV      = true
          NUXT_PUBLIC_DEBUG    = true
          NUXT_PUBLIC_SITE_URL = "http://localhost:${local.my_fe_port}"
          NUXT_PORT            = local.my_fe_port
          NUXT_HOST            = "0.0.0.0"
          # Debug
          LOG_LEVEL = "debug"
        }
      }
    }
    auto_deployments_enabled = true
  }

  health_check_configuration {
    path                = "/ping"
    healthy_threshold   = 1
    interval            = 20
    protocol            = "HTTP"
    timeout             = 19
    unhealthy_threshold = 20
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }


  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.my_vpc_connector.arn
    }

    ingress_configuration {
      is_publicly_accessible = true
    }

  }

  tags = {
    Name = "my-my_fe-apprunner-service"
  }
}

output "my_fe_apprunner_my_fe_service_url" {
  value       = aws_apprunner_service.my_fe.service_url
  description = ""
}
