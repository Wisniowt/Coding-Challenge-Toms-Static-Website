
locals {
  environments = ["dev", "prod"]
}

resource "aws_s3_bucket" "toms_website" {
  for_each = toset(local.environments)

  bucket = "${var.website_name}-${each.key}"
}

resource "aws_s3_account_public_access_block" "account" {
  account_id = "329599628498"

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "toms_website_public_block" {
  for_each = aws_s3_bucket.toms_website

  bucket = each.value.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "toms_website_policy" {
  for_each = aws_s3_bucket.toms_website

  bucket = each.value.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${each.value.arn}/*"
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
