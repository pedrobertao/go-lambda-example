// build the binary for the lambda function in a specified path
resource "null_resource" "function_binary" {
  provisioner "local-exec" {
    command = "GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOFLAGS=-trimpath go build -mod=readonly -ldflags='-s -w' -o ${local.binary_path} ${local.src_path}"
  }
}

// zip the binary, as we can use only zip files to AWS lambda
data "archive_file" "function_archive" {
  depends_on  = [null_resource.function_binary]
  type        = "zip"
  source_file = local.binary_path
  output_path = local.archive_path
}


resource "aws_lambda_function" "function" {
  function_name = local.function_name
  description   = "Get my ip function"
  role          = aws_iam_role.lambda.arn
  handler       = local.binary_name
  memory_size   = 128

  filename         = local.archive_path
  source_code_hash = data.archive_file.function_archive.output_base64sha256

  // skip timeout
  runtime = "go1.x"
  // skip tags

}
