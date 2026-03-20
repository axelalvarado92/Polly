resource "aws_sns_topic" "audio_ready" {
  name = "audio-ready-notification"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.audio_ready.arn
  protocol  = var.protocol_sns
  endpoint  = var.endpoint_sns 
}