resource "aws_iam_policy" "terraform_cloudwatch" {
  name        = "terraformProdRole-cloudwatch"
  description = "Allow Terraform to manage EKS CloudWatch log groups"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ManageEKSCloudWatchLogs"
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:DescribeLogGroups",
          "logs:PutRetentionPolicy",
          "logs:DeleteRetentionPolicy",
          "logs:TagResource",
          "logs:UntagResource",
          "logs:ListTagsForResource"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_cloudwatch" {
  role       = aws_iam_role.terraform_prod.name
  policy_arn = aws_iam_policy.terraform_cloudwatch.arn
}