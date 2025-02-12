provider "aws" {
  region = var.aws_region
}

# Bucketnamen randomisieren
resource "random_integer" "static_number" {
  min = 1000
  max = 9999
}

# s3 Bucket erstellen
resource "aws_s3_bucket" "site" {
  bucket = "${var.site_name}-${random_integer.static_number.result}"
}

# Zugriff auf den Bucket einschränken
resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Website Konfiguration
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Bucketzugriffsrechte
resource "aws_s3_bucket_acl" "site" {
  bucket = aws_s3_bucket.site.id
  acl    = "public-read"
  depends_on = [
    aws_s3_bucket_public_access_block.site,
    aws_s3_bucket_ownership_controls.site, aws_s3_bucket_public_access_block.site
  ]
}

# Bucket Policy
resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource = [
        aws_s3_bucket.site.arn,
        "${aws_s3_bucket.site.arn}/*"
      ]
    }]
  })
  depends_on = [
    aws_s3_bucket_public_access_block.site
  ]
}

# React-Build-Prozess starten
data "external" "react_build" {
  program = ["bash", "-c", <<EOT
    cd ./vite-project
    npm install > /dev/null 
    npm run build > /dev/null
    echo '{ "status": "completed" }'
  EOT
  ]
}

# Dateien aus dem React-Build in den Bucket kopieren
resource "aws_s3_object" "dist_files" {
  bucket   = aws_s3_bucket.site.id
  for_each = fileset("${path.module}/vite-project/dist", "**")
  key      = each.value
  source   = "${path.module}/vite-project/dist/${each.value}"
 content_type = lookup({
  ".js"   = "application/javascript",
  ".css"  = "text/css",
  ".html" = "text/html",
  ".png"  = "image/png",
  ".jpg"  = "image/jpeg",
  ".jpeg" = "image/jpeg",
  ".svg"  = "image/svg+xml",
  ".json" = "application/json",
  ".woff" = "font/woff",
  ".woff2" = "font/woff2"
}, regex("\\.[^.]+$", each.value), "application/octet-stream")

  depends_on = [
    data.external.react_build
  ]
}