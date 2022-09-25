# returns lambda layer ARN
output "lambda_layer_arn_requests_python" {
  value = aws_lambda_layer_version.requests_python.arn
}
