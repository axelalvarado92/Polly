resource "aws_s3_bucket" "my_bucket_s3" {
    bucket = "proyecto-polly-axel-7777-3606"
    
    tags = var.tags_bucket
}
### versionado de s3 ###
resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
    bucket = aws_s3_bucket.my_bucket_s3.id

    versioning_configuration {
      status = var.versioning_configuration
    }
}

### acceso publico blockeado ###
resource "aws_s3_bucket_public_access_block" "my_bucket_public_acces" {
    bucket = aws_s3_bucket.my_bucket_s3.id
    block_public_acls   = var.s3_public_access_block[0]
    ignore_public_acls = var.s3_public_access_block[1]
    block_public_policy = var.s3_public_access_block[2]
    restrict_public_buckets = var.s3_public_access_block[3]
}

### s3 notifica a lambda que se subio un archivo ###
resource "aws_s3_bucket_notification" "my_bucket_notification" {
    bucket = aws_s3_bucket.my_bucket_s3.id
    lambda_function {
        lambda_function_arn = aws_lambda_function.my_lambda_function.arn
        events = ["s3:ObjectCreated:*"]
        filter_prefix = "upload/"
        filter_suffix = ".txt"
    }
    depends_on = [ aws_lambda_permission.mi_permiso_lambda ]
}
