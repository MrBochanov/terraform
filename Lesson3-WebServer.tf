provider "aws" {
  region = "eu-central-1"
}

#создается машина и привязывается к создаваемой SG
resource "aws_instance" "my_aws_webserver" {
  count                  = 1
  ami                    = "ami-0e342d72b12109f91"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG_for_WebServer.id]
  user_data              = file("user_data.sh")
  tags = {
    Name    = "My Ubuntu WebServer in AWS"
    Owner   = "Evgeniy Bochanov"
    Project = "Terraform Lessons"
  }
}

#создается SG для WebServer
resource "aws_security_group" "SG_for_WebServer" {
  name        = "Web Server Security Group"
  description = "Allow http traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_security_group"
  }
}
