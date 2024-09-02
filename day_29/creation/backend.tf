terraform {
  backend "s3" {
    bucket         = "yaksh-terraform-bucket" 
    key            = "terraform/state.tfstate"
    region         = "ap-south-1" 
    encrypt        = true
    dynamodb_table = "yaksh-locks" 
  }
}