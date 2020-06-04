provider "aws" {
  region = "eu-central-1"
}

#создается машина и привязывается к создаваемой SG
resource "aws_instance" "my_aws_webserver" {
  count                  = 1
  ami                    = "ami-0e342d72b12109f91"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG_for_WebServer.id]
  user_data              = <<EOF
#!/bin/bash
apt -y update
apt -y install apache2
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo service apache2 start
chkconfig apache2 on
EOF

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
