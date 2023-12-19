# my_api
resource "aws_ecr_repository" "my_ecr_api" {
  name                 = "my_ecr/my_api"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "my_ecr_api" {
  repository = aws_ecr_repository.my_ecr_api.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

output "my_ecr_api_registry_id" {
  value       = aws_ecr_repository.my_ecr_api.registry_id
  description = ""
}
output "my_ecr_api_repository_url" {
  value       = aws_ecr_repository.my_ecr_api.repository_url
  description = ""
}
