### main settings for project, avoid rewrite variables etc...
variable "region" {
  default = "us-west-2"
}
variable "account_id" {
  description = "Id of the account, needed in some resources"
  default = ""
}
variable "environment" {
  default = "dev"
}
variable "namespace" {
  default = "practice"
  description = "Basically, the name of the project"
}
variable "delimiter" {
  default = "-"
}