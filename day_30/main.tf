provider "aws" {
  region = "ap-south-1"
}

module "aws_infrastructure" {
  source           = "./modules/aws_infrastructure"
  ami_id           = "ami-0c2af51e265bd5e0e"  
  instance_type    = "t2.micro"
  key_name         = "My_key"         
  bucket_name      = "my-uni-buc-name" 
  private_key_path = "~/.ssh/My_key.pem"         
}
