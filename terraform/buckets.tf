
locals {
  environments = ["dev", "prod"]
}

resource "aws_s3_bucket" "toms_website" {
  for_each = toset(local.environments)

  bucket = "${var.website_name}-${each.key}"
}

resource "aws_s3_bucket_public_access_block" "toms_website_public_block" {
  for_each = aws_s3_bucket.toms_website

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "toms_website_policy" {
  for_each = aws_s3_bucket.toms_website

  bucket = each.value.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServiceOnly"
        Effect = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action = "s3:GetObject"
        Resource = "${each.value.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.prod[each.key].arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "toms_website" {
  for_each = aws_s3_bucket.toms_website

  bucket = each.value.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = aws_s3_bucket.toms_website

  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}
