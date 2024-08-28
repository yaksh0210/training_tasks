provider "aws" {
  region = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0c2af51e265bd5e0e"
}

variable "db_password" {
  type      = string
  sensitive = true
}