resource "aws_iam_role" "terraform_prod" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600
  tags = { ManagedBy = "bootstrap", Environment = "production" }
}

resource "aws_iam_policy" "eks" {
  name   = "${var.role_name}-eks"
  policy = data.aws_iam_policy_document.eks.json
}

resource "aws_iam_policy" "network" {
  name   = "${var.role_name}-network"
  policy = data.aws_iam_policy_document.network.json
}

resource "aws_iam_policy" "s3" {
  name   = "${var.role_name}-s3"
  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_policy" "sm" {
  name   = "${var.role_name}-sm"
  policy = data.aws_iam_policy_document.sm.json
}

/*resource "aws_iam_policy" "boundary" {
  name   = "${var.role_name}-created-role-boundary"
  policy = data.aws_iam_policy_document.boundary.json
}*/

resource "aws_iam_policy" "iam" {
  name   = "${var.role_name}-iam"
  policy = data.aws_iam_policy_document.iam.json
}

resource "aws_iam_role_policy_attachment" "execution" {
  for_each = {
    eks     = aws_iam_policy.eks.arn
    network = aws_iam_policy.network.arn
    s3      = aws_iam_policy.s3.arn
    iam     = aws_iam_policy.iam.arn
    sm      = aws_iam_policy.sm.arn
  }
  role       = aws_iam_role.terraform_prod.name
  policy_arn = each.value
}

#**Permission assume for user
resource "aws_iam_user_policy" "assume" {
  name = "AssumeTerraformProdRole"
  user = var.bootstrap_user
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Resource = aws_iam_role.terraform_prod.arn
    }]
  })
}
