variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_name" {
  description = "A name prefix for the EC2 instance"
  type        = string
  default     = "app"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "new-value-yaksh"
}