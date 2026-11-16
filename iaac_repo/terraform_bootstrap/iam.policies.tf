#user trust policy
data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowInfraUser"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:user/${var.bootstrap_user}"]
    }
  }
}

#eks iam policy
data "aws_iam_policy_document" "eks" {
  statement {
    sid = "ManageEKS"
    actions = [
      "eks:CreateCluster", 
      "eks:DescribeCluster", 
      "eks:ListClusters", 
      "eks:UpdateClusterConfig", 
      "eks:UpdateClusterVersion", 
      "eks:DeleteCluster",
      "eks:CreateNodegroup", 
      "eks:DescribeNodegroup", 
      "eks:ListNodegroups", 
      "eks:UpdateNodegroupConfig", 
      "eks:UpdateNodegroupVersion", 
      "eks:DeleteNodegroup",
      "eks:CreateAddon", 
      "eks:DescribeAddon", 
      "eks:ListAddons", 
      "eks:UpdateAddon", 
      "eks:DeleteAddon",
      "eks:CreatePodIdentityAssociation", 
      "eks:DescribePodIdentityAssociation", 
      "eks:ListPodIdentityAssociations", 
      "eks:UpdatePodIdentityAssociation", 
      "eks:DeletePodIdentityAssociation",
      "eks:CreateAccessEntry", 
      "eks:DescribeAccessEntry", 
      "eks:ListAccessEntries", 
      "eks:UpdateAccessEntry", 
      "eks:DeleteAccessEntry",
      "eks:AssociateAccessPolicy", 
      "eks:DisassociateAccessPolicy", 
      "eks:ListAssociatedAccessPolicies",
      "eks:TagResource", 
      "eks:UntagResource", 
      "eks:ListTagsForResource"
    ]
    resources = ["*"]
  }
}

#network iam policy
data "aws_iam_policy_document" "network" {
  statement {
    sid = "ManageVpcNetworking"
    actions = [
      "ec2:CreateVpc", 
      "ec2:DeleteVpc", 
      "ec2:ModifyVpcAttribute", 
      "ec2:DescribeVpcs", 
      "ec2:DescribeVpcAttribute",
      "ec2:CreateSubnet", 
      "ec2:DeleteSubnet", 
      "ec2:ModifySubnetAttribute", 
      "ec2:DescribeSubnets",
      "ec2:CreateInternetGateway", 
      "ec2:AttachInternetGateway", 
      "ec2:DetachInternetGateway", 
      "ec2:DeleteInternetGateway", 
      "ec2:DescribeInternetGateways",
      "ec2:CreateNatGateway", 
      "ec2:DeleteNatGateway", 
      "ec2:DescribeNatGateways",
      "ec2:AllocateAddress", 
      "ec2:ReleaseAddress", 
      "ec2:DescribeAddresses", 
      "ec2:AssociateAddress", 
      "ec2:DisassociateAddress",
      "ec2:CreateRouteTable", 
      "ec2:DeleteRouteTable", 
      "ec2:DescribeRouteTables", 
      "ec2:CreateRoute", 
      "ec2:ReplaceRoute", 
      "ec2:DeleteRoute",
      "ec2:AssociateRouteTable", 
      "ec2:DisassociateRouteTable", 
      "ec2:ReplaceRouteTableAssociation",
      "ec2:CreateSecurityGroup", 
      "ec2:DeleteSecurityGroup", 
      "ec2:DescribeSecurityGroups", 
      "ec2:AuthorizeSecurityGroupIngress", 
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress", 
      "ec2:RevokeSecurityGroupEgress", 
      "ec2:ModifySecurityGroupRules", 
      "ec2:DescribeSecurityGroupRules",
      "ec2:DescribeNetworkInterfaces", 
      "ec2:DescribeAvailabilityZones", 
      "ec2:DescribeInstanceTypes", 
      "ec2:DescribeImages",
      "ec2:CreateTags", 
      "ec2:DeleteTags", 
      "ec2:DescribeTags", 
      "ec2:DescribeAccountAttributes", 
      "ec2:DescribeAddressesAttribute",
      "ec2:DescribeInstanceCreditSpecifications",
      "ec2:RunInstances",
      "ec2:DescribeInstances",
      "ec2:TerminateInstances",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeVolumes",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:StopInstances",
      "ec2:ModifyInstanceAttribute",
      "ec2:StartInstances"
    ]
    resources = ["*"]
  }
}
#TODO: check the resource limitations to add on permission policies

#s3 iam policy
data "aws_iam_policy_document" "s3" {
  statement {
    sid = "ManageBuckets"
    actions = [
      "s3:CreateBucket", 
      "s3:DeleteBucket", 
      "s3:ListAllMyBuckets", 
      "s3:ListBucket", 
      "s3:GetBucketLocation",
      "s3:GetBucketPolicy", 
      "s3:PutBucketPolicy", 
      "s3:DeleteBucketPolicy", 
      "s3:GetBucketVersioning", 
      "s3:PutBucketVersioning",
      "s3:GetEncryptionConfiguration", 
      "s3:PutEncryptionConfiguration", 
      "s3:GetBucketPublicAccessBlock", 
      "s3:PutBucketPublicAccessBlock", 
      "s3:DeleteBucketPublicAccessBlock",
      "s3:GetBucketTagging", 
      "s3:PutBucketTagging", 
      "s3:DeleteBucketTagging", 
      "s3:GetBucketOwnershipControls", 
      "s3:PutBucketOwnershipControls", 
      "s3:DeleteBucketOwnershipControls",
      "s3:GetBucketAcl", 
      "s3:PutBucketAcl", 
      "s3:GetBucketLogging", 
      "s3:PutBucketLogging", 
      "s3:GetBucketWebsite", 
      "s3:PutBucketWebsite", 
      "s3:DeleteBucketWebsite",
      "s3:GetLifecycleConfiguration", 
      "s3:PutLifecycleConfiguration", 
      "s3:GetBucketNotification", 
      "s3:PutBucketNotification",
      "s3:GetObject", 
      "s3:PutObject", 
      "s3:DeleteObject", 
      "s3:ListBucketVersions",
      "s3:GetBucketCORS",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketRequestPayment",
      "s3:GetReplicationConfiguration",
      "s3:GetBucketObjectLockConfiguration"
    ]
    resources = ["*"]
  }
}

#aws iam boundary policy
data "aws_iam_policy_document" "boundary" {
  statement {
    sid = "ApprovedInfrastructureRoleCeiling"
    actions = [
      "ec2:Describe*", 
      "ec2:AssignPrivateIpAddresses", 
      "ec2:UnassignPrivateIpAddresses", 
      "ec2:CreateNetworkInterface", 
      "ec2:DeleteNetworkInterface", 
      "ec2:AttachNetworkInterface", 
      "ec2:DetachNetworkInterface", 
      "ec2:ModifyNetworkInterfaceAttribute",
      "eks:DescribeCluster", 
      "eks-auth:AssumeRoleForPodIdentity", 
      "ecr:GetAuthorizationToken", 
      "ecr:BatchCheckLayerAvailability", 
      "ecr:GetDownloadUrlForLayer", 
      "ecr:BatchGetImage",
      "logs:CreateLogGroup", 
      "logs:CreateLogStream", 
      "logs:PutLogEvents", 
      "cloudwatch:PutMetricData", 
      "s3:GetObject", 
      "s3:ListBucket",
      "s3:GetBucketCORS",
      "secretsmanager:GetSecretValue", 
      "kms:Decrypt",
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

#aws iam policy
data "aws_iam_policy_document" "iam" {
  statement {
    sid = "CreateBoundedRoles"
    actions = ["iam:CreateRole"]
    resources = ["arn:aws:iam::${var.account_id}:role/terraform-managed/*"]
    /*condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values   = [aws_iam_policy.boundary.arn]
    }*/
  }
  statement {
    sid = "ManageApprovedRoles"
    actions = [
      "iam:GetRole", 
      "iam:DeleteRole", 
      "iam:UpdateAssumeRolePolicy", 
      "iam:TagRole", 
      "iam:UntagRole",
      "iam:AttachRolePolicy", 
      "iam:DetachRolePolicy", 
      "iam:ListAttachedRolePolicies", 
      "iam:PutRolePolicy", 
      "iam:GetRolePolicy", 
      "iam:DeleteRolePolicy", 
      "iam:ListRolePolicies",
      "iam:ListRoleTags", 
      "iam:ListInstanceProfilesForRole",
      "iam:CreateServiceLinkedRole",
    ]
    resources = ["arn:aws:iam::${var.account_id}:role/terraform-managed/*"]
  }
  statement {
    sid = "PassApprovedRolesToServices"
    actions = ["iam:PassRole"]
    resources = ["arn:aws:iam::${var.account_id}:role/terraform-managed/*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["eks.amazonaws.com", "ec2.amazonaws.com", "pods.eks.amazonaws.com"]
    }
  }
  statement {
    sid = "ManageApprovedPolicies"
    actions = [
      "iam:CreatePolicy", "iam:DeletePolicy", "iam:GetPolicy", "iam:GetPolicyVersion", "iam:CreatePolicyVersion", "iam:DeletePolicyVersion", "iam:ListPolicyVersions", "iam:TagPolicy", "iam:UntagPolicy"
    ]
    resources = ["arn:aws:iam::${var.account_id}:policy/terraform-managed/*"]
  }
  statement {
    sid = "ReadIAMMetadata"
    actions = ["iam:ListRoles", "iam:ListPolicies", "iam:ListInstanceProfiles", "iam:GetInstanceProfile"]
    resources = ["*"]
  }
  statement {
    sid = "ManageApprovedInstanceProfiles"
    actions = ["iam:CreateInstanceProfile", "iam:DeleteInstanceProfile", "iam:AddRoleToInstanceProfile", "iam:RemoveRoleFromInstanceProfile", "iam:TagInstanceProfile"]
    resources = ["arn:aws:iam::${var.account_id}:instance-profile/terraform-managed/*"]
  }
  #**AWS Service Roles
  statement {
    sid    = "CreateEKSServiceLinkedRoles"
    effect = "Allow"

    actions = [
        "iam:CreateServiceLinkedRole"
    ]

    resources = [
        "arn:aws:iam::${var.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS",
        "arn:aws:iam::${var.account_id}:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"
    ]

    condition {
        test     = "StringEquals"
        variable = "iam:AWSServiceName"

        values = [
        "eks.amazonaws.com",
        "eks-nodegroup.amazonaws.com"
        ]
    }
  }
  statement {
    sid    = "ReadEKSServiceLinkedRoles"
    effect = "Allow"

    actions = [
        "iam:GetRole"
    ]

    resources = [
        "arn:aws:iam::${var.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS",
        "arn:aws:iam::${var.account_id}:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"
    ]
  }
  statement {
    sid = "ListOIDCProviders"
    effect = "Allow"
    actions = [
      "iam:ListOpenIDConnectProviders"
    ]
    resources = ["*"]
  }
  statement {
    sid = "ReadGitHubOIDCProvider"
    effect = "Allow"
    actions = [
      "iam:GetOpenIDConnectProvider"
    ]
    resources = ["arn:aws:iam::731770490737:oidc-provider/token.actions.githubusercontent.com"]
  }
  statement {
    sid = "ManageGitHubOIDCProvider"
    effect = "Allow"
    actions = [
      "iam:CreateOpenIDConnectProvider",
      "iam:GetOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:RemoveClientIDFromOpenIDConnectProvider",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider",
      "iam:ListOpenIDConnectProviderTags"
    ]
    resources = ["arn:aws:iam::731770490737:oidc-provider/token.actions.githubusercontent.com"]
  }
}