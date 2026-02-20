data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_permission" {
  statement {
    effect    = "Allow"
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
      ]
    resources = ["arn:aws:logs:*:*:*"]
  }
  
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
      "${aws_s3_bucket.my_bucket_s3.arn}/output/*" ### esto es para que lambda no lea cualquier bucket s3 ###
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "polly:SynthesizeSpeech"
    ]
    resources = ["*"]
  }
  statement {                                      ### le doy el permiso a SNS
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.audio_ready.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-polly-policy"
  policy      = data.aws_iam_policy_document.lambda_permission.json
}

resource "aws_iam_policy_attachment" "lambda_attach" {
  name       = "lambda-polly-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}
