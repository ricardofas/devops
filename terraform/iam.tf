data "aws_iam_policy_document" "s3_full_admin" {
  statement {
    sid    = "S3FullAccess"
    effect = "Allow"

    actions = [
      "s3:*",
      "s3-object-lambda:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "s3_full_admin" {
  name        = "S3FullAdminAccess"
  description = "Full access to all S3 buckets and objects"
  policy      = data.aws_iam_policy_document.s3_full_admin.json
}

output "policy_arn" {
  value = aws_iam_policy.s3_full_admin.arn
}
