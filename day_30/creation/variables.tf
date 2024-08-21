variable "bucket" {
    type = string
    default = "yaksh-terraform-bucket"
}

variable "instance_name" {
    type = string
    default = "yaksh-app"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "region" {
    type = string
    default = "ap-south-1"
}