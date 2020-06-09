terraform {
    backend "s3" {
        bucket = "terraform-states"
        key = "path/"
        dynamodb_table = "terraform-states"
    }
}