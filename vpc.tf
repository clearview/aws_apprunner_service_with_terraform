resource "aws_apprunner_vpc_connector" "my_vpc_connector" {
  vpc_connector_name = "my_vpc_connector"
  subnets = [
    aws_subnet.my_dev_private_subnet_a.id,
    aws_subnet.my_dev_rds_private_subnet_a.id,
    aws_subnet.my_dev_rds_private_subnet_b.id
  ]
  security_groups = [
    aws_security_group.my_apprunner_api_sg.id
  ]

  depends_on = [
    aws_subnet.my_dev_private_subnet_a,
    aws_subnet.my_dev_rds_private_subnet_a,
    aws_subnet.my_dev_rds_private_subnet_b,
    aws_security_group.my_rds
  ]
}
