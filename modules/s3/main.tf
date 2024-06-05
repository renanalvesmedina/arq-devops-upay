resource "aws_s3_bucket" "upay-front-s3" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_cors_configuration" "upay-front-s3" {
  bucket = aws_s3_bucket.upay-front-s3.id  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}

resource "aws_s3_bucket_website_configuration" "upay-front-s3" {
  bucket = aws_s3_bucket.upay-front-s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

resource "aws_s3_bucket_acl" "upay-front-s3" {
  bucket = aws_s3_bucket.upay-front-s3.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.upay-front-s3]
}

resource "aws_s3_bucket_ownership_controls" "upay-front-s3" {
  bucket = aws_s3_bucket.upay-front-s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_iam_user" "upay-front-bucket" {
  name = "upay-front-bucket"
}

resource "aws_s3_bucket_public_access_block" "upay-front-s3" {
  bucket = aws_s3_bucket.upay-front-s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "upay-front-bucket" {
    bucket = aws_s3_bucket.upay-front-s3.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.upay-front-s3]
}
