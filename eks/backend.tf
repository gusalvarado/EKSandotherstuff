terraform {
    backend "s3" {
        bucket = "gustavo-terraform"
        key = "tests/"
        region = "us-west-2"
        dynamodb_table = "terraform-lock"
    }
}