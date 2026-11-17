resource "aws_iam_policy" "alb_controller" {
  name   = "${var.cluster_name}-alb-controller"
  path   = "/terraform-managed/"
  policy = file("${path.module}/alb-iam-policy.json")
}
