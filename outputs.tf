# URL der Website formattieren und ausgeben
output "website_url" {
  value = format("http://%s",
  aws_s3_bucket_website_configuration.site.website_endpoint)
  description = "value of the site"

}