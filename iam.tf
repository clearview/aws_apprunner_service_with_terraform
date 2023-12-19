resource "aws_iam_role" "my_app_runner_roles" {
  name = "my_app_runner_roles"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "build.apprunner.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my_app_runner_rolespolicy" {
  role       = aws_iam_role.my_app_runner_roles.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "time_sleep" "waitrolecreate" {
  depends_on      = [aws_iam_role.my_app_runner_roles]
  create_duration = "60s"
}
