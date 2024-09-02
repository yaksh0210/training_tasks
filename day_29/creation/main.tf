provider "aws" {
  region  = "ap-south-1"
}

module "modules" {
  source          = "./modules/"
  ami_id          = "ami-0c2af51e265bd5e0e"
  instance_type   = var.instance_type
  region          = var.region
  instance_name   = var.instance_name
  bucket_name     = var.bucket
}
