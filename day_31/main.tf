provider "aws" {
  region = "us-east-1"
}

module "aws_infrastructure" {
  source           = "./modules/aws_infrastructure"
  ami_id           = "ami-0a0e5d9c7acc336f1"  
  instance_type    = "t2.micro"
  key_name         = "SPkey"         
  bucket_name      = "my-uni-buc-name" 
  private_key_path = "~/.ssh/SPkey.pem"         
}
