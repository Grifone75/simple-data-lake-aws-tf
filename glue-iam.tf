resource "aws_iam_role" "fg_glue_role" {
  name = "fg-glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue-assume-role-policy.json
}

data "aws_iam_policy_document" "glue-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "extra_policy" {
  name = "extra-policy"
  description = "a test policy"
  policy      = data.aws_iam_policy_document.extra-policy-document.json
}

data "aws_iam_policy_document" "extra-policy-document" {
  statement {
    actions = [
    "s3:GetBucketLocation", "s3:ListBucket", "s3:ListAllMyBuckets", "s3:GetBucketAcl", "s3:GetObject"]
    resources = [
    "arn:aws:s3:::${var.data_lake_bucket_name}",
    "arn:aws:s3:::${var.data_lake_bucket_name}/*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "extra_policy_attachment" {
  role = aws_iam_role.fg_glue_role.name
  policy_arn = aws_iam_policy.extra_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_service_role_attachment" {
  role = aws_iam_role.fg_glue_role.name
  policy_arn = data.aws_iam_policy.AWSGlueServiceRole.arn
}

data "aws_iam_policy" "AWSGlueServiceRole"{
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"  
}

