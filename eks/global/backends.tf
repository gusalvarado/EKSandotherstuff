resource "aws_s3_bucket" "terraform-lock" {
    bucket = "gustavo-terraform"
    region = "us-west-2"
}
resource "aws_dynamodb_table" "terraform_state_lock" {
    name = "terraform-lock"
    read_capacity = 5
    write_capacity = 5
    hash_key = "LockID"

attribute {
    name = "LockID"
    type = "S"
}
}