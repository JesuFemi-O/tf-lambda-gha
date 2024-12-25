data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/../src/lambda_function.zip"
}


# I had to deploy this using:
# https://ystoneman.medium.com/stop-making-your-own-aws-lambda-layers-9a18e7e055d
# data "aws_lambda_layer_version" "aws_sdk_pandas" {
#   layer_name = "AWSSDKPandas-Python310"
# }

resource "aws_lambda_function" "faker_lambda_function" {
  function_name = "faker_lambda_function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = data.archive_file.lambda_function.output_path

  layers = [
    aws_lambda_layer_version.lambda_layer.arn,
    # data.aws_lambda_layer_version.aws_sdk_pandas.arn
  ]

  source_code_hash = filebase64sha256(data.archive_file.lambda_function.output_path)

  # Configure memory and timeout
  memory_size = 256
  timeout     = 300 # 5 minutes in seconds


  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}

# function url
resource "aws_lambda_function_url" "example_function_url" {
  function_name      = aws_lambda_function.faker_lambda_function.function_name
  authorization_type = "NONE" # Options: NONE (no auth) or AWS_IAM (IAM-based auth)
}