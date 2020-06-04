provider "aws" {
  region = "eu-central-1"
}


#создается SG для WebServer
resource "aws_security_group" "SG_for_WebServer" {
  name        = "Web Server Security Group"
  description = "Allow http traffic"

  #пример динамического кода - много одинаковых портов
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  #если для одного правила другие - прописывается отсдельно, то есть статикой
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.10.0/24"]
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
