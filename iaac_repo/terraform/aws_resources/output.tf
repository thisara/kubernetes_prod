output "aws_s3_enc_secret_arn" {
  description = "ARN of the AWS_S3_ENC secret."
  value       = aws_secretsmanager_secret.aws_s3_enc.arn
}