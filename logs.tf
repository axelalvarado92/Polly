### log group de cloudwatch ###
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.my_lambda_function.function_name}"
  retention_in_days = 7 # Los logs se borran tras 7 días (ahorro de costos)
}