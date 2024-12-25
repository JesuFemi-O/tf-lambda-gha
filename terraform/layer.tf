# Archive the Lambda layer
data "archive_file" "lambda_layer" {
  type        = "zip"
  source_dir  = "${path.module}/../layers/custom_layer"
  output_path = "${path.module}/../layers/lambda_layer.zip"
}

# Create the Lambda Layer
resource "aws_lambda_layer_version" "lambda_layer" {
  filename            = data.archive_file.lambda_layer.output_path
  layer_name          = "sql_alchemy_layer"
  compatible_runtimes = ["python3.10"]
  # Use the requirements.txt hash to ensure changes trigger updates
  source_code_hash    = filesha256("${path.module}/../layers/requirements.txt")
}
