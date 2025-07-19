resource "aws_s3_bucket" "gwagnsan-s3" {
  bucket = "${var.prefix}-s3"

  tags = {
    Name        = "${var.prefix}-s3"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "gwangsan_public_access_block" {
  bucket = aws_s3_bucket.gwagnsan-s3.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}



resource "aws_s3_bucket_policy" "gwangsan_policy" {
  bucket = aws_s3_bucket.gwagnsan-s3.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowGitHubOIDC",
        Effect    = "Allow",
        Principal = "*",
        Action    = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource  = "${aws_s3_bucket.gwagnsan-s3.arn}/*"
      },
      {
        Sid       = "AllowCodeBuild",
        Effect    = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action    = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource  = "${aws_s3_bucket.gwagnsan-s3.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.gwangsan_public_access_block]
}
