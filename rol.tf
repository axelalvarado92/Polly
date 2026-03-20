resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}


data "aws_iam_policy_document" "lambda_permission" {

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.my_bucket_s3.arn}/upload/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.my_bucket_s3.arn}/output/*" ### esto es para que lambda lea solo el bucket creado aqui 
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "polly:SynthesizeSpeech"
    ]
    resources = ["*"]
  }
  statement {                                      
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.audio_ready.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {                ### adjunto las permisos de la policy document 
  name        = "lambda-polly-policy"
  policy      = data.aws_iam_policy_document.lambda_permission.json
}

resource "aws_iam_policy_attachment" "lambda_attach" {
  name       = "${var.project_name}-lambda-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}