provider "aws" {
  access_key = "ACCESSKEY"
  secret_key = "SECRETKEY"
  region     = "eu-central-1"
}

resource "aws_instance" "aws_ubuntu" {
  count         = 2
  ami           = "ami-0e342d72b12109f91"
  instance_type = "t2.micro"

  tags = {
    Name    = "My Ubuntu in AWS"
    Owner   = "Evgeniy Bochanov"
    Project = "Terraform Lessons"
  }
}
