resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

output "vpc_id" {
  value = aws_vpc.default.id
}

### VPC flow logs

resource "aws_flow_log" "test_flow_log" {
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  iam_role_arn    = aws_iam_role.vpc_flowlogs_role.arn
  vpc_id          = aws_vpc.default.id
  traffic_type    = "ALL"
}

resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name = var.vpc_cloudwatch_log_group
}

resource "aws_iam_role" "vpc_flowlogs_role" {
  name = var.vpc_flowlogs_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "vpc_flowlogs_policy" {
  name = var.vpc_flowlogs_policy_name
  role = aws_iam_role.vpc_flowlogs_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

output "vpc_flow_log_group_name" {
  value = aws_flow_log.test_flow_log.log_group_name
}

