variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
  
}

variable "tags_bucket" {
    description = "Tags for S3 bucket"
    type = map(string)
    default = {
        Name = "txt_my_bucket_s3"
        Environment = "dev"
        Owner = "Axel"
        project = "Polly project"
    }
        
}

variable "versioning_configuration" {
    description = "Versioning configuration for S3 bucket"
    type = string
    default = "Enabled"
}

variable "s3_public_access_block" {
    description = "Public access block configuration for S3 bucket"
    type = list(bool)
    default = [true, true, true, true]
}

 variable "protocol_sns" {
    description = "Protocol for SNS topic"
    type = string
    default = "email"
}

  variable "endpoint_sns" {
    description = "Endpoint for SNS topic"
    type = string
    default = "axel.lp92@gmail.com"
}

