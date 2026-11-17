resource "aws_secretsmanager_secret" "aws_s3_enc" {
  name = "AWS_S3_ENC"
  description             = "File API S3 encryption key"

  lifecycle {
    prevent_destroy = true
  }
}
