# File API Helm chart

Install External Secrets Operator (with external-secrets.io/v1 CRDs), AWS Load Balancer Controller, and Metrics Server in the EKS cluster first. Nodes need permission to pull the ECR image, and ALB discovery needs appropriately tagged subnets.

Create an IRSA role whose OIDC trust allows `sts:AssumeRoleWithWebIdentity` for `system:serviceaccount:<namespace>:<release>-file-api-app` with audience `sts.amazonaws.com`. Grant access to the application bucket (`s3:ListBucket` on the bucket and the required object read/write/delete actions on its objects), plus `secretsmanager:GetSecretValue` and `secretsmanager:DescribeSecret` on the encryption secret. Grant `kms:Decrypt` if the secret uses a customer managed KMS key. The service account is used by both the application and the SecretStore.

Store the existing AWS_S3_ENC value from your local .env in AWS Secrets Manager as the plaintext secret `encryption-key`. Do not commit the key or AWS credentials. For a JSON secret, set `externalSecrets.property=AWS_S3_ENC` and set `externalSecrets.remoteKey` to its name or ARN.

```sh
helm upgrade --install file-api ./helm_repo/file_api_app \
  --namespace file-api --create-namespace \
  --set serviceAccount.roleArn=arn:aws:iam::731770490737:role/FILE_API_ROLE \
  --set config.AWS_S3_BUCKET=YOUR_BUCKET \
  --set image.tag=YOUR_IMAGE_TAG
```

Nonsecret environment variables come from `config` in values.yaml. The deployment restarts when its ConfigMap changes. After a secret rotation, restart the deployment to reload its environment variable. The deployment and HPA specify two replicas; rolling updates use no surge and may temporarily leave one available pod. Both probes and the ALB use `/health`; probe settings are configurable. ALB defaults to HTTP; provide certificate and listener annotations in `ingress.annotations` for HTTPS.

