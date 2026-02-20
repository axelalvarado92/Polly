data "archive_file" "my_archive_file" {
    type = "zip"
    source_file = "lambda_function.py"
    output_path = "lambda_function_payload.zip"
}
### le agrego source_code_hash para que actualice el zip para lambda ###
resource "aws_lambda_function" "my_lambda_function" {
    filename = data.archive_file.my_archive_file.output_path
    source_code_hash = data.archive_file.my_archive_file.output_base64sha256
    function_name = "proyecto-polly"
    role = aws_iam_role.lambda_role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.12"

    environment {
      variables = {
        SNS_TOPIC_ARN = aws_sns_topic.audio_ready.arn
      }
    }
}
resource "aws_lambda_permission" "mi_permiso_lambda" {
    statement_id = "AllowS3Invoke" 
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.my_lambda_function.function_name
    principal = "s3.amazonaws.com"
    source_arn = aws_s3_bucket.my_bucket_s3.arn
}
