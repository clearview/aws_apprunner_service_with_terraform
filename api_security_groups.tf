# API
resource "aws_security_group" "my_apprunner_api_sg" {
  name        = "my_apprunner_api_sg"
  description = "my_apprunner_api_sg"
  vpc_id      = aws_vpc.my_dev_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-api-security-group"
  }
}
