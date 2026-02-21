# depends_on
resource "aws_s3_bucket" "bucket1" {
  count  = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  tags = var.tags
}

resource "aws_s3_bucket" "bucket-set" {
    for_each = var.bucket_names_set
    bucket = each.value

    tags = var.tags

    depends_on = [ aws_s3_bucket.bucket1 ]
}