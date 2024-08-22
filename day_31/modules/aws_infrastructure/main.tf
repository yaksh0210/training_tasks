provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
  ami            = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name

  tags = {
    Name = "my-ec2-instance-yaksh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {

  command = "echo 'EC2 instance successfully provisioned with Apache' >> terraform_output.log"

  }

}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

